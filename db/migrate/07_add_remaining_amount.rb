class AddRemainingAmount < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :remaining_amount, :numeric
  end
end
