class AddDateToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :date, :timestamps
  end
end
