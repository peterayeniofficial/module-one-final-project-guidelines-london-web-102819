class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :amount
      t.integer :user_id
      t.integer :budget_id
      t.integer :category_id
    end
  end
end
