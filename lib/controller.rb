
require_relative "../lib/view.rb"
require_all "lib"
require "pry"

module Controller
  include View

  @@prompt = TTY::Prompt.new

  def welcome_screen
    system("clear")
    brand
    choices = ["Create account", "Log in", "Quit"]
    input = @@prompt.select("Please select an option to get started", choices)
    finish = false

    if input == "Create account"
      create_account
    elsif input == "Log in"
      log_in
    else
      puts "Goodbye!"
    end
  end

  def create_account
    brand

    name = @@prompt.ask("Please enter your full name:", required: true) do |q|
      q.validate(/\A[a-zA-Z]*\s[a-zA-Z]*\z/, "Please enter first & last name only.")
    end

    email = @@prompt.ask("Please enter your email address:", required: true) { |q| q.validate :email }

    password = @@prompt.mask("Please choose a password:", required: true) do |q|
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
    email = @@prompt.ask("What is your email address?", required: true) { |q| q.validate :email }

    password = @@prompt.mask("Please enter your password:", required: true) do |q|
      q.validate(/\A[a-zA-Z0-9]*\z{5,15}/)
    end
    @owner = User.login_check(email, password)
    if @owner == nil
      puts "There is no existing account with that email and password. Please re-enter your account details, or create a new account."
      welcome_screen
    else
      dashboard
    end
  end

  def sign_out
    @owner = nil
    welcome_screen
  end

  def main_menu
    choices = ["Create a budget", "Add an expense", "My budgets", "My expenses", "Log out", "Delete account"]
    if @owner.has_budget == false
      choices.delete_at(1)
      choices.delete_at(1)
      choices.delete_at(1)
    end
    input = @@prompt.select("\nWhat will you like to do?", choices)
    if input == "Create a budget"
      create_budget_display
      add_budget
    elsif input == "Add an expense"
      add_expenses_display
      add_expense
    elsif input == "My budgets"
      my_budgets_display
      my_budgets
      main_menu
    elsif input == "My expenses"
      my_expenses_display
      my_expenses
    elsif input == "Log out"
      sign_out
    elsif input == "Delete account"
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
    puts "Welcome #{@owner.name}!"
    main_menu
  end

  def delete_account
    input = @@prompt.yes?("Are you sure you want to delete your account?")
    if input == "yes"
      @owner.destroy
      sign_out
    else
      dashboard
    end
  end

  def add_budget
    choices = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    month = @@prompt.select("Please select a month:", choices)
    amount = @@prompt.ask("Please enter the budget amount:", required: true, convert: :float)
    @owner.add_budget(month, amount)
    my_budgets
    main_menu
  end

  def my_budgets
    puts "#{@owner.name}'s budgets"
    puts "===============================================\n"
    puts "\nBudget ID      | Month      | Amount      | Remaining amount\n\n"
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
    id = @@prompt.ask("Please enter the ID of the budget your new expense is for?", required: true)
    this_budget = @owner.budgets.find_by(id: id)
    if this_budget == nil
      puts "You don't have budget with that ID, please add a new budget"
      main_menu
    else
      name = @@prompt.ask("What are you buying?", required: true)
      choices = ["Groceries", "Transportation", "Utilities", "Entertainment", "Clothing", "Housing", "Savings"]
      category = @@prompt.select("Please select a category", choices)
      amount = @@prompt.ask("Please enter amount", required: true, convert: :float)
      
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
    puts "#{@owner.name}'s expenses"
    puts "===============================================\n"
    puts "\nExpense ID      | Name          | Amount      | Category     | Budget Month\n\n"
    @owner.expenses.reload
    render_expenses(@owner.expenses)
    main_menu
  end

  def delete_expense
    my_expenses
    id = @@prompt.ask("Please enter the ID of the expense you want to delete?", required: true)
    expense = @owner.expenses.find_by(id: id)
    if expense == nil
      puts "You don't have an expense with that ID. Please select another ID."
      #main_menu
    else
      input = @@prompt.yes?("Are you sure you want to delete this expense?")
      if input == "yes"
        expense.destroy
      else
        dashboard
      end
    end
  end 

  def update_expense
    
  end 

end
