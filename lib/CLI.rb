require_relative "../lib/controller.rb"

class CommandLineInterface
  include Controller

  def run
    puts "Welcome to Budgety"
    data_for_new_budget
  end
end
