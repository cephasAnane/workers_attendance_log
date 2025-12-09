class CreatePaymentRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.text :reason
      t.integer :status

      t.timestamps
    end
  end
end
