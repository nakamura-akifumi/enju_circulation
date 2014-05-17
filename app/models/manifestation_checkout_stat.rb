class ManifestationCheckoutStat < ActiveRecord::Base
  #attr_accessible :start_date, :end_date, :note
  include CalculateStat
  default_scope {order('manifestation_checkout_stats.id DESC')}
  scope :not_calculated, -> {where(:state => 'pending')}
  has_many :checkout_stat_has_manifestations
  has_many :manifestations, :through => :checkout_stat_has_manifestations

  state_machine :initial => :pending do
    before_transition :pending => :completed, :do => :calculate_count
    event :calculate do
      transition :pending => :completed
    end
  end

  paginates_per 10

  def calculate_count
    self.started_at = Time.zone.now
    Manifestation.find_each do |manifestation|
      daily_count = Checkout.manifestations_count(start_date.beginning_of_day, end_date.tomorrow.beginning_of_day, manifestation)
      #manifestation.update_attributes({:daily_checkouts_count => daily_count, :total_count => manifestation.total_count + daily_count})
      if daily_count > 0
        self.manifestations << manifestation
        sql = ['UPDATE checkout_stat_has_manifestations SET checkouts_count = ? WHERE manifestation_checkout_stat_id = ? AND manifestation_id = ?', daily_count, self.id, manifestation.id]
        ManifestationCheckoutStat.connection.execute(
          self.class.send(:sanitize_sql_array, sql)
        )
      end
    end
    self.completed_at = Time.zone.now
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
#  state        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#

