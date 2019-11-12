require_relative '../lib/controller.rb'
class CommandLineInterface
  include Controller

  def run
    puts "Welcome to Budgety"
    log_in
  end
end
