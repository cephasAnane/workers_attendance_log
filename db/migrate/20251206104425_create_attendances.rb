class CreateAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :check_in
      t.datetime :check_out
      t.float :latitude
      t.string :ip_address
      t.text :note

      t.timestamps
    end
  end
end
