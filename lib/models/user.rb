class User < ActiveRecord::Base
  has_many :budgets
  has_many :expenses, through: :budgets


  def self.create_user(name, email, password)
    self.create(name: name, email: email, password: password)
  end

  def self.login_check(email, password)
    self.find_by(email: email, password:password)
  end

end
