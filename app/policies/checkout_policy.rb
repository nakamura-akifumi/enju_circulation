class CheckoutPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    if user.try(:has_role?, 'Librarian')
      true
    elsif user and user == record.user
      true
    end
  end

  def create?
    user.try(:has_role?, 'Librarian')
  end

  def update?
    if user.try(:has_role?, 'Librarian')
      true
    elsif user and user == record.user
      true
    end
  end

  def destroy?
    false
  end

  def remove_all?
    true if user.try(:has_role?, 'User')
  end
end
