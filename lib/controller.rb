
require_relative '../lib/view.rb'
require_all "lib"


module Controller
  include View

  @@prompt = TTY::Prompt.new

  def welcome_screen
    system("clear")
    brand
    choices = ["Create Account", "Login", "Quit"]
    input = @@prompt.select("Please select a menu to get started", choices)
    if input == "Create Account"
      create_account
    elsif input == "Login"
      log_in
    else
      puts "Good Bye"
    end
  end


  def create_account
    brand
    name = @@prompt.ask('What is your name?', required: true) do |q|
      q.validate /\A[a-zA-Z0-9]*\z/
    end

    email = @@prompt.ask('What is your email?', required: true) { |q| q.validate :email }

    password = @@prompt.mask('Choose a password?', required: true) do |q|
      q.validate(/\A[a-zA-Z0-9]*\z{5,15}/)
    end
    @owner = User.create_user(name, email, password)
    if @owner
      dashboard
    else
      welcome_screen
    end
  end

  def log_in
    email = @@prompt.ask('What is your email?', required: true) { |q| q.validate :email }

    password = @@prompt.mask('What is your password?', required: true) do |q|
      q.validate(/\A[a-zA-Z0-9]*\z{5,15}/)
    end
    @owner = User.login_check(email, password)
    if @owner == nil
      puts "You don't have account with us please: Create Account"
      create_account
    else
      dashboard
    end
  end

  def sign_out
    @owner = nil
    welcome_screen
  end

  def main_menu
    choices = ["Add a Budget", "Add Expenses", "My Budgets", "My Expenses", "Log Out", "Delete Account"]
    input = @@prompt.select("Please select a menu to get started", choices)
    if input == "Add a Budget"
      create_budget_display
      "Add Budget"
    elsif input == "Add Expenses"
      add_expenses_display
      "Add Expense"
    elsif input == "My Budgets"
      my_budgets_display
      "Budgets"
    elsif input == "My Expenses"
      my_expenses_display
      "Expenses"
    elsif input == "Log Out"
      sign_out
    elsif input == "Delete Account"
      delete_account_display
      puts "\n\n"
      delete_account
    else
      "Save now, Enjoy Later"
    end
  end

  def dashboard
    brand
    puts "#{@owner.name} Welcome"
    main_menu
  end

  def delete_account
    input = @@prompt.yes?('Are you sure you want to delete your Account?')
    if input == "yes"
      @owner.destroy
    else
      dashboard
    end
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
