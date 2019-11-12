class Expense < ActiveRecord::Base
  belongs_to :user
  belongs_to :budget
  belongs_to :category

  def all_expenses
    self.expenses
  end 

end
