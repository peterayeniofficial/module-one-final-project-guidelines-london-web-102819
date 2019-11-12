require_relative '../lib/user_controller.rb'

module Controller
  include UserController

  $user = nil

  def create_account
   
    puts "Welcome to Budgety Please enter the following info to get started"
    puts "Please Enter your Full Name"
    name = gets.chomp
    puts "Please Enter your Email: example@gmail.com"
    email = gets.chomp
    puts "Please Enter your password"
    password = gets.chomp

    sign_up(name, email, password)
  end

  def log_in
    puts "Please Enter your Email: example@gmail.com"
    email = gets.chomp
    puts "Please Enter your password"
    password = gets.chomp

    sign_in(email, password)
  end

  def sign_out
    $user = nil
  end


  
end
