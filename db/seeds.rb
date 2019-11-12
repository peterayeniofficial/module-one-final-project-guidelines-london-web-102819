# Add Users

7.times do
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
5.times do
  amount = Faker::Number.decimal(l_digits: 4)
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
Category.create(name: "Groceries") #1
Category.create(name: "Transportation") #2
Category.create(name: "Utilities")#3
Category.create(name: "Entertainment") #4
Category.create(name: "Housing") #5
Category.create(name: "Savings") #6


# Add Expenses


5.times do
  groceries = ["Milk", "Toothpaste", "Celery", "Mustad", "Eggs", "Shaving Cream", "Body Cream"]
  amount = Faker::Number.decimal(l_digits: 2)

  Expense.create( 
    name: groceries.sample,
    amount: amount, 
    user_id: User.all.sample.id, 
    budget_id: Budget.all.sample.id, 
    category_id: 1,
  )
end

5.times do
  utilities = ["Internet", "Water", "Electricity"]
  amount = Faker::Number.decimal(l_digits: 2)

  Expense.create( 
    name: utilities.sample,
    amount: amount, 
    user_id: User.all.sample.id, 
    budget_id: Budget.all.sample.id, 
    category_id: 3,
  )
end
