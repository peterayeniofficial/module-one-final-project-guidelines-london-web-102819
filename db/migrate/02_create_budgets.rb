class CreateBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :budgets do |t|
      t.string :month
      t.numeric :amount
      t.integer :user_id
      t.timestamps
    end
    
  end
end
