class ItemHasUseRestriction < ActiveRecord::Base
  attr_accessible
  attr_accessible :item_id, :use_restriction_id, :as => :admin
  belongs_to :item, :validate => true
  belongs_to :use_restriction, :validate => true
  accepts_nested_attributes_for :use_restriction

  validates_associated :item, :use_restriction
  validates_presence_of :use_restriction
  validates_presence_of :item, :on => :update

  def self.per_page
    10
  end
end

# == Schema Information
#
# Table name: item_has_use_restrictions
#
#  id                 :integer         not null, primary key
#  item_id            :integer         not null
#  use_restriction_id :integer         not null
#  created_at         :datetime
#  updated_at         :datetime
#

