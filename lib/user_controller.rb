module UserController

  def sign_up(name, email, password)
    User.create(name: name, email: email, password: password)
  end

  

  def sign_in(email, password)
    user = login_check(email, password)
    if user == false 
      puts "The email address or password you have entered is incorrect."
      log_in
    else
      $user = user
      puts "Welcome #{ $user.name }!"
    end
  end

end
