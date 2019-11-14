
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

  def all_expenses_budget(budget_id)
    amount = 0
    array = Expense.all.select { |e|
      e.budget_id == budget_id
    }
    array.each { |a|
      amount += a.amount
    }
    amount
  end

  def budget_menu
    choices = ["Update budget", "Delete budget", "Go back"]
    input = @@prompt.select("\nPlease select an option:", choices)
    if input == "Update Budget"
      id = @@prompt.ask("Please Enter the ID of the budget you want to update", required: true).to_i
      budget = @owner.budgets.find_by(id: id)
      amount = @@prompt.ask("Please Enter the Amount", required: true).to_f
      total_expenses = all_expenses_budget(id)
      rem_amount = amount - total_expenses
      # binding.pry
      budget.update(amount: amount)
      budget.update(remaining_amount: rem_amount)
      my_budgets
      budget_menu
    elsif input == "Delete Budget"
      delete_budget
    else
      main_menu
    end
  end

  def expense_menu
    choices = ["Update expense", "Delete expense", "Go back"]
    input = @@prompt.select("\nPlease select an option:", choices)
    if input == "Update expense"
      id = @@prompt.ask("Please enter the ID of the expense you want to update", required: true).to_i
      expense = @owner.expenses.find_by(id: id)
      amount = @@prompt.ask("Please enter the amount", required: true).to_f
      total_expenses = all_expenses_budget(id)
      rem_amount = amount - total_expenses
      # binding.pry
      budget.update(amount: amount)
      budget.update(remaining_amount: rem_amount)
      my_budgets
      budget_menu
    elsif input == "Delete expense"
      delete_expense
    else
      main_menu
    end
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
      budget_menu
      # main_menu
    elsif input == "My expenses"
      my_expenses_display
      my_expenses
      expense_menu
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
      main_menu
    end
  end

  def my_expenses
    puts "#{@owner.name}'s expenses"
    puts "===============================================\n"
    puts "\nExpense ID      | Name          | Amount      | Category     | Budget Month\n\n"
    @owner.expenses.reload
    render_expenses(@owner.expenses)
    #main_menu
  end

  def delete_account
    choices = ["Yes", "No"]
    input = @@prompt.select("Are you sure you want to delete your account?", choices)
    if input == "Yes"
      @owner.destroy
      sign_out
    else
      dashboard
    end
  end

  def delete_expense
    choices = ["Yes", "No"]
    my_expenses
    id = @@prompt.ask("Please enter the ID of the expense you want to delete?", required: true).to_i
    expense = @owner.expenses.find_by(id: id)
    if expense == nil
      puts "You don't have an expense with that ID. Please select another ID."
      delete_expense
    else
      input = @@prompt.select("Are you sure you want to delete this expense?", choices)
      if input == "Yes"
        expense.destroy
        puts "Your expense has been deleted."
        dashboard
      else
        dashboard
      end
    end
  end 


    def delete_budget
      my_budgets
      id = @@prompt.ask("Please enter the ID of the budget you want to delete?", required: true)
      budget = @owner.budget.find_by(id: id)
      if budget == nil
        puts "You don't have budget with that ID. Please select another ID."
        #main_menu
      else
        choices = ["Yes", "No"]
        input = @@prompt.select("Are you sure you want to delete your account?", choices)
        if input == "Yes"
          budget.destroy
        else
          dashboard
        end
      end
  end

end
