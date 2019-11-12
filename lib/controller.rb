require_relative '../lib/user_controller.rb'

module Controller
  include UserController

  $user = nil

  def create_account
   
    puts "Welcome to Budgety! Please enter the following information to get started."
    puts "Please enter your full name:"
    name = gets.chomp
    puts "Please enter your email address:"
    email = gets.chomp
    puts "Please enter a password:"
    password = gets.chomp

    sign_up(name, email, password)
  end

  def log_in
    puts "Please enter your email address:"
    email = gets.chomp
    puts "Please enter your password:"
    password = gets.chomp

    sign_in(email, password)
  end

  def sign_out
    $user = nil
  end


  
end
