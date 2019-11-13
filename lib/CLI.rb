require_relative "../lib/controller.rb"

class CommandLineInterface
  include Controller

  @user = nil
  @budget = nil

  def run
    puts "Welcome to Budgety"
    data_for_new_expense
  end
end
