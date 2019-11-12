class Expense < ActiveRecord::Base
  belongs_to :users
  belongs_to :budgets
  belongs_to :categories
end
