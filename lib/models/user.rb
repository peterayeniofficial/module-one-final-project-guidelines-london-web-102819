class User < ActiveRecord::Base
  has_many :expenses
  has_many :budgets, through: :expenses
end
