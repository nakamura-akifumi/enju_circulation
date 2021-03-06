class ManifestationReserveStatTransition < ActiveRecord::Base
  #include Statesman::Adapters::ActiveRecordTransition

  belongs_to :manifestation_reserve_stat, inverse_of: :manifestation_reserve_stat_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: manifestation_reserve_stat_transitions
#
#  id                            :integer          not null, primary key
#  to_state                      :string           not null
#  metadata                      :jsonb
#  sort_key                      :integer          not null
#  manifestation_reserve_stat_id :integer          not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  most_recent                   :boolean
#
