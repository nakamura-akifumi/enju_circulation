class UserCheckoutStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :started
  state :completed

  transition from: :pending, to: [:started, :completed]

  before_transition(to: :completed) do |user_checkout_stat|
    user_checkout_stat.calculate_count!
  end
end
