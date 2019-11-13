class User < ActiveRecord::Base
  has_many :budgets
  has_many :expenses, through: :budgets
  
  def self.login_check(email, password)
    get_user = User.find_by(email: email, password:password)
    if get_user == nil
      return false
    else
      get_user
    end
  end
  
end
