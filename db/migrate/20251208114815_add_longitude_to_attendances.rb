class AddLongitudeToAttendances < ActiveRecord::Migration[8.1]
  def change
    add_column :attendances, :longitude, :float
  end
end
