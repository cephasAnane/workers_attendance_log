class AddSalaryToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :hourly_rate, :decimal, precision: 10, scale: 2
  end
end
