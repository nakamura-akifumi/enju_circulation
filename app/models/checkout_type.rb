class CheckoutType < ActiveRecord::Base
  include MasterModel
  default_scope {order("checkout_types.position")}
  scope :available_for_carrier_type, lambda {|carrier_type| includes(:carrier_types).where('carrier_types.name = ?', carrier_type.name).references(:carrier_types).order('carrier_types.position')}
  scope :available_for_user_group, lambda {|user_group| includes(:user_groups).where('user_groups.name = ?', user_group.name).references(:user_groups).order('user_group.position')}

  has_many :user_group_has_checkout_types, :dependent => :destroy
  has_many :user_groups, :through => :user_group_has_checkout_types
  has_many :carrier_type_has_checkout_types, :dependent => :destroy
  has_many :carrier_types, :through => :carrier_type_has_checkout_types
  #has_many :item_has_checkout_types, :dependent => :destroy
  #has_many :items, :through => :item_has_checkout_types
  has_many :items

  paginates_per 10
end

# == Schema Information
#
# Table name: checkout_types
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

