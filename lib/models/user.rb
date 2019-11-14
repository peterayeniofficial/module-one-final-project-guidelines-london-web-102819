class User < ActiveRecord::Base
  has_many :budgets
  has_many :expenses, through: :budgets

  def has_budget
    Budget.all.any? { |b|
      b.user_id == self.id
    }
  end

  def self.create_user(name, email, password)
    self.create(name: name, email: email, password: password)
  end

  def self.login_check(email, password)
    self.find_by(email: email, password: password)
  end

  def get_budget(budget_id)
    Budget.all.find { |b|
      b.budget_id == budget_id
    }
  end

  def add_budget(month, amount)
    Budget.create(month: month, amount: amount, user_id: self.id, remaining_amount: amount)
  end

  def get_budget_for_month(month)
    my_budgets.find { |b| b.month == month }
  end

  def add_expenses(name, amount, budget_id, category)
    Expense.create(name: name, amount: amount, budget_id: budget_id, category: category)
  end

end
