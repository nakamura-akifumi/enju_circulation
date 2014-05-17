class ManifestationReserveStat < ActiveRecord::Base
  #attr_accessible :start_date, :end_date, :note
  include CalculateStat
  default_scope {order('manifestation_reserve_stats.id DESC')}
  scope :not_calculated, -> {where(:state => 'pending')}
  has_many :reserve_stat_has_manifestations
  has_many :manifestations, :through => :reserve_stat_has_manifestations

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
      daily_count = manifestation.reserves.created(start_date.beginning_of_day, end_date.tomorrow.beginning_of_day).size
      #manifestation.update_attributes({:daily_reserves_count => daily_count, :total_count => manifestation.total_count + daily_count})
      if daily_count > 0
        self.manifestations << manifestation
        sql = ['UPDATE reserve_stat_has_manifestations SET reserves_count = ? WHERE manifestation_reserve_stat_id = ? AND manifestation_id = ?', daily_count, self.id, manifestation.id]
        ManifestationReserveStat.connection.execute(
          self.class.send(:sanitize_sql_array, sql)
        )
      end
    end
    self.completed_at = Time.zone.now
  end
end

# == Schema Information
#
# Table name: manifestation_reserve_stats
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

