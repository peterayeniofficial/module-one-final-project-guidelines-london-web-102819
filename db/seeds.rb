# Add Users

20.times do
  name = Faker::FunnyName.two_word_name
  email = Faker::Internet.email
  password = Faker::Lorem.characters(number: 10, min_alpha: 4, min_numeric: 1)    
  User.create(
    name: name,
    email: email,
    password: password
  )
end

# Add budgets
30.times do
  amount = Faker::Number.decimal(l_digits: 2)
  months = [
    "January", 
    "February", 
    "March", 
    "April", 
    "May", 
    "June", 
    "July", 
    "August", 
    "September", 
    "October", 
    "November", 
    "December"
  ]
  Budget.create(
    month: months.sample,
    amount: amount
  )
end

# ADD categories
Category.create(name: "Groceries")
Category.create(name: "Transportation")
Category.create(name: "Utilities")
Category.create(name: "Entertainment")
Category.create(name: "Housing")
Category.create(name: "Savings")


# Add Expenses


5.times do
  groceries = []
  amount = Faker::Number.decimal(l_digits: 2)

  Expense.create( 
    name: groceries.sample,
    amount: amount, 
    user_id: User.all.sample.id, 
    budget_id: Budget.all.sample.id, 
    category_id: 1,
  )
end
