class UserCheckoutStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :started
  state :completed

  transition from: :pending, to: :started
  transition from: :started, to: :completed

  after_transition(to: :started) do |user_checkout_stat|
    user_checkout_stat.update_column(:started_at, Time.zone.now)
    user_checkout_stat.calculate_count!
  end

  after_transition(to: :started) do |user_checkout_stat|
    user_checkout_stat.update_column(:completed_at, Time.zone.now)
  end
end
