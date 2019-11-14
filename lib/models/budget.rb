class Budget < ActiveRecord::Base
  belongs_to :user
  has_many :expenses

  def update_expense(expense, new_amount)
    if expense.budget_id != self.id
      return
    end

    self.remaining_amount += expense.amount
    self.remaining_amount -= new_amount

    self.update(remaining_amount: self.remaining_amount)
    expense.update(amount: new_amount)
  end

  def get_all_expenses
    Expense.all.select { |e| e.budget_id == self.id }
  end
end
