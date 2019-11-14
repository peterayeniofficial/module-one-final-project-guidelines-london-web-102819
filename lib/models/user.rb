class User < ActiveRecord::Base
  has_many :budgets
  has_many :expenses, through: :budgets

  def self.create_user(name, email, password)
    self.create(name: name, email: email, password: password)
  end

  def self.login_check(email, password)
    self.find_by(email: email, password:password)
  end

  def add_budget(month, amount)
    Budget.create(month: month, amount: amount, user_id: self.id, remaining_amount: amount)
  end

  def add_expenses(name, amount, id, category)
    Expense.create(name: name, amount: amount, budget_id: id, category: category)
  end

end
