class ReserveStatHasManifestation < ActiveRecord::Base
  attr_accessible
  attr_accessible :manifestation_reserve_stat_id, :manifestation_id,
    as: :admin
  belongs_to :manifestation_reserve_stat
  belongs_to :manifestation

  validates_uniqueness_of :manifestation_id, scope: :manifestation_reserve_stat_id
  validates_presence_of :manifestation_reserve_stat_id, :manifestation_id

  paginates_per 10
end

# == Schema Information
#
# Table name: reserve_stat_has_manifestations
#
#  id                            :integer          not null, primary key
#  manifestation_reserve_stat_id :integer          not null
#  manifestation_id              :integer          not null
#  reserves_count                :integer
#  created_at                    :datetime
#  updated_at                    :datetime
#
