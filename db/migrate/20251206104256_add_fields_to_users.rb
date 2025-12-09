class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :role, :integer
    add_reference :users, :department, null: false, foreign_key: true
  end
end
