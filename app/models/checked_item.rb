class CheckedItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :basket
  belongs_to :librarian, class_name: 'User'

  validates_associated :item, :basket, on: :update
  validates_presence_of :item, :basket, :due_date, on: :update
  validates_uniqueness_of :item_id, scope: :basket_id
  validate :available_for_checkout?, on: :create
  validates :due_date_string, format: { with: /\A\[{0,1}\d+([\/-]\d{0,2}){0,2}\]{0,1}\z/ }, allow_blank: true
  validate :check_due_date
  validate :check_reserved
  validate :check_checkout_count

  before_validation :set_item
  before_validation :set_due_date, on: :create
  strip_attributes only: :item_identifier

  # attr_protected :user_id
  attr_accessor :item_identifier, :ignore_restriction, :due_date_string

  def available_for_checkout?
    if item.blank?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.item_not_found')
      return false
    end

    if item.rent?
      unless item.circulation_status.name == 'Missing'
        errors[:base] << I18n.t('activerecord.errors.messages.checked_item.already_checked_out')
      end
    end

    if item.circulation_status.name == 'Missing'
      item.circulation_status = CirculationStatus.find_by(name: 'Available On Shelf')
      item.save
      set_due_date
    end

    unless item.available_for_checkout?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.not_available_for_checkout')
      return false
    end

    if item_checkout_type.blank?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.this_group_cannot_checkout')
      return false
    end
    # ここまでは絶対に貸出ができない場合

    return true if ignore_restriction == '1'

    if item.not_for_loan?
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.not_available_for_checkout')
    end

    if errors[:base].empty?
      true
    else
      false
    end
  end

  def check_reserved
    return unless item
    if item.reserved?
      unless item.manifestation.next_reservation.user == basket.user
        errors[:base] << I18n.t('activerecord.errors.messages.checked_item.reserved_item_included')
      end
    end
  end

  def check_checkout_count
    return unless item_checkout_type
    checkout_count = basket.user.checked_item_count
    checkout_type = item_checkout_type.checkout_type
    if checkout_count[:"#{checkout_type.name}"] >= item_checkout_type.checkout_limit
      errors[:base] << I18n.t('activerecord.errors.messages.checked_item.excessed_checkout_limit')
    end
  end

  def item_checkout_type
    if item && basket
      basket.user.profile.user_group.user_group_has_checkout_types.available_for_item(item).first
    end
  end

  def set_due_date
    return nil unless item_checkout_type
    if due_date_string.present?
      self.due_date = Time.zone.parse(due_date_string).try(:end_of_day)
    else
      if item_checkout_type.fixed_due_date.blank?
        self.due_date = item_checkout_type.checkout_period.days.since(Time.zone.now).end_of_day
      else
        self.due_date = item_checkout_type.fixed_due_date.tomorrow.end_of_day
      end
      # 返却期限日が閉館日の場合
      while item.shelf.library.closed?(due_date)
        self.due_date = if item_checkout_type.set_due_date_before_closing_day
                          due_date.yesterday.end_of_day
                        else
                          due_date.tomorrow.end_of_day
                        end
      end
    end
    due_date
  end

  def set_item
    identifier = item_identifier.to_s.strip
    if identifier.present?
      item = Item.find_by(item_identifier: identifier)
      self.item = item
    end
  end

  private

  def check_due_date
    return nil unless due_date
    errors.add(:due_date) if due_date <= Time.zone.now
  end
end

# == Schema Information
#
# Table name: checked_items
#
#  id           :integer          not null, primary key
#  item_id      :uuid             not null
#  basket_id    :uuid             not null
#  due_date     :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  librarian_id :integer
#
