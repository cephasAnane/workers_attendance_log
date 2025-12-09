class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.date :payment_date
      t.integer :status
      t.string :month
      t.text :note

      t.timestamps
    end
  end
end
