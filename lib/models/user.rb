class User < ActiveRecord::Base
  has_many :expenses
  has_many :budgets, through: :expenses

  def all_expenses
    Expenses.all.map { |e| b.user_id == self.id }
  end

  def month_expenses(month)
    all_expenses.map { |e| e.budget.month == month }
  end 
  
end
