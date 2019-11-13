require_relative "../lib/user_controller.rb"
require_all "lib"

module Controller
  include UserController


  def create_account
    puts "Welcome to Budgety! Please enter the following information to get started."
    puts "Please enter your full name:"
    name = gets.chomp
    puts "Please enter your email address:"
    email = gets.chomp
    puts "Please enter a password:"
    password = gets.chomp

    sign_up(name, email, password)
  end

  def log_in
    puts "Please enter your email address:"
    email = gets.chomp
    puts "Please enter your password:"
    password = gets.chomp

    sign_in(email, password)
  end

  def sign_out
    $user = nil
  end

  def data_for_new_budget
    $user = User.first
    puts "Please Enter Month"
    month = gets.chomp
    puts "Please Enter Amount"
    amount = gets.chomp
    create_budget(month, amount)
  end

  def create_budget(month, amount)
    $budget = Budget.create(month: month, amount: amount, remaining_amount: amount)
  end

  def create_expense(name, amount, budget, category)
    Expense.create(name: name, amount: amount, budget_id: budget, category: category)
  end 
  

end
