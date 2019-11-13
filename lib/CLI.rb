require_relative "../lib/controller.rb"
require_relative '../lib/view.rb'


class CommandLineInterface
  include Controller
  include View

  def run
    puts "Welcome to Budgety"
    welcome_screen
  end
end
