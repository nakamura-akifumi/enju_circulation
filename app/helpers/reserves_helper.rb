module ReservesHelper
  include ManifestationsHelper rescue nil
  def i18n_state(state)
    case state
    when 'pending'
      t('reserve.pending')
    when 'requested'
      t('reserve.requested')
    when 'retained'
      t('reserve.retained')
    when 'canceled'
      t('reserve.canceled')
    when 'expired'
      t('reserve.expired')
    when 'postponed'
      t('reserve.postponed')
    when 'completed'
      t('reserve.completed')
    end
  end
end
