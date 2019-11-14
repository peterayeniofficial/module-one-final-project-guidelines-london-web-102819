require_relative "../lib/controller.rb"
require_relative "../lib/view.rb"
require_all "lib"

class CommandLineInterface
  include Controller
  include View

  def run
    puts "Welcome to Budgety"
    welcome_screen
  end

  # def data_for_new_expense
  #   @budget = Budget.first
  #   budget = @budget.id

  #   puts "Please enter name of expense:"
  #   name = gets.chomp
  #   puts "Please choose category:"
  #   category = gets.chomp
  #   puts "Please enter amount:"
  #   amount = gets.chomp.to_i

  #   new_expense = create_expense(name, amount, budget, category)
  #   new_expense.budget.remaining_amount -= amount
  #   new_expense.budget.save
  # end
end
