
require_relative "../lib/view.rb"
require_all "lib"
require "pry"

module Controller
  include View

  @@prompt = TTY::Prompt.new

  def welcome_screen
    system("clear")
    brand
    choices = ["Create Account", "Login", "Quit"]
    input = @@prompt.select("Please select a menu to get started", choices)
    finish = false

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

    name = @@prompt.ask("What is your name?", required: true) do |q|
      q.validate(/\A[a-zA-Z]*\s[a-zA-Z]*\z/, "Please enter First & Last Name Only")
    end

    email = @@prompt.ask("What is your email?", required: true) { |q| q.validate :email }

    password = @@prompt.mask("Choose a password?", required: true) do |q|
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
    email = @@prompt.ask("What is your email?", required: true) { |q| q.validate :email }

    password = @@prompt.mask("What is your password?", required: true) do |q|
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
    if @owner.has_budget == false
      choices.delete_at(1)
      choices.delete_at(1)
      choices.delete_at(1)
    end
    input = @@prompt.select("\nWhat will you like to do?", choices)
    if input == "Add a Budget"
      create_budget_display
      add_budget
    elsif input == "Add Expenses"
      add_expenses_display
      add_expense
    elsif input == "My Budgets"
      my_budgets_display
      my_budgets
      main_menu
    elsif input == "My Expenses"
      my_expenses_display
      my_expenses
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

  def process_add_expense
    months = @owner.my_budgets.map { |budget| "#{budget.month}" }
    month_selected = @@prompt.select("Please select a budget", months)
    budget = @owner.get_budget_for_month(month_selected)

    puts "Total amount: #{budget.amount}"
    puts "Remaining amount: #{budget.remaining_amount}"
  end

  def dashboard
    brand
    puts "#{@owner.name} Welcome"
    main_menu
  end

  def delete_account
    input = @@prompt.yes?("Are you sure you want to delete your Account?")
    if input == "yes"
      @owner.destroy
      sign_out
    else
      dashboard
    end
  end

  def add_budget
    choices = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    month = @@prompt.select("Please select Month", choices)
    amount = @@prompt.ask("Please Enter Amount", required: true, convert: :float)
    @owner.add_budget(month, amount)
    my_budgets
    main_menu
  end

  def my_budgets
    puts "Kindly find your budgets bellow: #{@owner.name}"
    puts "===============================================\n"
    puts "\nBudget ID      | Month      | Amount      | Remaining Amount\n\n"
    @owner.budgets.reload
    render_budgets(@owner.budgets)
    # header = ["Month", "Amount", "Remaining Amount"]
    # rows = [['aaa1', 'aa2', 'aaaaaaa3'], ['b1', 'b2', 'b3']]
    # table = TTY::Table.new header, rows
    # table.render  width: 80, resize: true
    # main_menu
  end

  def add_expense
    my_budgets
    id = @@prompt.ask("Please enter the ID of the Budget you are spending from?", required: true)
    this_budget = @owner.budgets.find_by(id: id)
    if this_budget == nil
      puts "You don't have budget with that ID please add a new budget"
      main_menu
    else
      name = @@prompt.ask("What are you buying?", required: true)
      choices = ["Groceries", "Transportation", "Utilities", "Entertainment", "Housing", "Savings"]
      category = @@prompt.select("Please select Category", choices)
      amount = @@prompt.ask("Please Enter Amount", required: true, convert: :float)
      
      new_expense = @owner.add_expenses(name, amount, id, category)
      new_expense.budget.remaining_amount -= amount 
      new_expense.budget.save
      @owner.save

      
      # new_amount = this_budget.remaining_amount.to_i - amount
      # this_budget.update(remaining_amount: new_amount)
      # this_budget.save
      # @owner.add_expenses(name, amount, id, category)

      my_expenses
    end
  end

  

  def my_expenses
    puts "Kindly find your expenses bellow: #{@owner.name}"
    puts "===============================================\n"
    puts "\nExpense ID      | Name          | Amount      | Category     | Budget Month\n\n"
    @owner.expenses.reload
    render_expenses(@owner.expenses)
    main_menu
  end
end
