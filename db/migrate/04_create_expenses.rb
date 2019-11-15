class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :name
      t.numeric :amount
      t.integer :budget_id
      t.string :category
      t.timestamps
    end
  end
end
