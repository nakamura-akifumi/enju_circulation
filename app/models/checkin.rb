class Checkin < ActiveRecord::Base
  default_scope {order('checkins.id DESC')}
  scope :on, lambda {|date| where('created_at >= ? AND created_at < ?', date.beginning_of_day, date.tomorrow.beginning_of_day)}
  has_one :checkout
  belongs_to :item, touch: true
  belongs_to :librarian, :class_name => 'User'
  belongs_to :basket

  validates_uniqueness_of :item_id, :scope => :basket_id
  validates_presence_of :item_id, :basket_id
  validate :available_for_checkin?, :on => :create
  before_validation :set_item

  attr_accessor :item_identifier

  paginates_per 10

  def available_for_checkin?
    unless basket
      return nil
    end

    if item.blank?
      errors[:base] << I18n.t('checkin.item_not_found')
      return
    end

    if basket.items.where('item_id = ?', item.id).first
      errors[:base] << I18n.t('checkin.already_checked_in')
    end
  end

  def item_checkin(current_user)
    message = ''
    Checkin.transaction do
      checkouts = Checkout.not_returned.where(:item_id => item_id).select(
        [:id, :item_id, :user_id, :basket_id, :due_date, :lock_version, :created_at, :checkout_renewal_count, :librarian_id]
      )
      item.checkin!
      checkouts.each do |checkout|
        # TODO: ILL時の処理
        checkout.checkin = self
        checkout.operator = current_user
        unless checkout.user.try(:save_checkout_history)
          checkout.user = nil
        end
        checkout.save(:validate => false)
        unless checkout.item.shelf.library == current_user.library
          message << I18n.t('checkin.other_library_item')
        end
      end

      if item.reserved?
        # TODO: もっと目立たせるために別画面を表示するべき？
        message << I18n.t('item.this_item_is_reserved')
        item.retain(current_user)
      end

      if item.include_supplements?
        message << I18n.t('item.this_item_include_supplement')
      end

      if item.circulation_status.name == 'Missing'
        message << I18n.t('checkout.missing_item_found')
      end

      # メールとメッセージの送信
      #ReservationNotifier.deliver_reserved(item.manifestation.reserves.first.user, item.manifestation)
      #Message.create(:sender => current_user, :receiver => item.manifestation.next_reservation.user, :subject => message_template.title, :body => message_template.body, :recipient => item.manifestation.next_reservation.user)
    end
    if message.present?
      message
    else
      nil
    end
  end

  def set_item
    identifier = item_identifier.to_s.strip
    if identifier.present?
      item = Item.where(:item_identifier => identifier).first
      self.item = item
    end
  end
end

# == Schema Information
#
# Table name: checkins
#
#  id           :integer          not null, primary key
#  item_id      :integer          not null
#  librarian_id :integer
#  basket_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#

