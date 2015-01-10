class ItemStateMachine
  include Statesman::Machine
  state :in_process, initial: true
  state :on_loan
  state :available_on_shelf
  state :lost
  state :missing

  transition from: :in_process, to: [:on_loan, :available_on_shelf]
  transition from: :available_on_shelf, to: [:available_on_shelf, :on_loan, :missing]
  transition from: :on_loan, to: [:available_on_shelf, :missing]
  transition from: :missing, to: [:lost, :available_on_shelf, :on_loan]
  transition from: :lost, to: [:available_on_shelf, :on_loan]

  before_transition(to: :on_loan) do |item|
    item.circulation_status = CirculationStatus.where(name: 'On Loan').first
  end

  before_transition(to: :available_on_shelf) do |item|
    item.circulation_status = CirculationStatus.where(name: 'Available On Shelf').first
  end
end