require_relative "../lib/controller.rb"
require 'pry'
require_all "lib"

class CommandLineInterface
  include Controller

  @user = nil
  @budget = nil

  def run
    puts "Welcome to Budgety"
    data_for_new_expense
  end

  def data_for_new_expense
    @budget = Budget.first
    budget = @budget.id
    #binding.pry
    puts "Please enter name of expense:"
    name = gets.chomp 
    puts "Please choose category:"
    category = gets.chomp
    puts "Please enter amount:"
    amount = gets.chomp.to_i
    

    new_expense = create_expense(name, amount, budget, category)
    new_expense.budget.remaining_amount -= amount
    new_expense.budget.save
  end 

  

  
end
