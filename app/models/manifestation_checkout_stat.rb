class ManifestationCheckoutStat < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include CalculateStat
  scope :not_calculated, -> { in_state(:pending) }
  has_many :checkout_stat_has_manifestations
  has_many :manifestations, through: :checkout_stat_has_manifestations
  belongs_to :user

  paginates_per 10
  attr_accessor :mode

  has_many :manifestation_checkout_stat_transitions

  def state_machine
    ManifestationCheckoutStatStateMachine.new(self, transition_class: ManifestationCheckoutStatTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
           to: :state_machine

  def calculate_count!
    self.started_at = Time.zone.now
    Manifestation.find_each do |manifestation|
      daily_count = Checkout.manifestations_count(start_date.beginning_of_day, end_date.tomorrow.beginning_of_day, manifestation)
      if daily_count > 0
        manifestations << manifestation
        sql = ['UPDATE checkout_stat_has_manifestations SET checkouts_count = ? WHERE manifestation_checkout_stat_id = ? AND manifestation_id = ?', daily_count, id, manifestation.id]
        ManifestationCheckoutStat.connection.execute(
          self.class.send(:sanitize_sql_array, sql)
        )
      end
    end
    self.completed_at = Time.zone.now
    transition_to!(:completed)
    send_message
  end

  private

  def self.transition_class
    ManifestationCheckoutStatTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: manifestation_checkout_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#  user_id      :integer
#
