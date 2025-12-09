class CreateLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :leave_type
      t.integer :status
      t.text :reason

      t.timestamps
    end
  end
end
