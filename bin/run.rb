require_relative "../config/environment"
require_relative "../lib/controller.rb"
require_relative "../lib/view.rb"
cli = CommandLineInterface.new

cli.run
