require 'csv'

class Attendance < ApplicationRecord
  has_paper_trail
  belongs_to :user

  validates :check_in, presence: true
  validate :check_out_after_check_in

  # Allow searching (Ransack)
  def self.ransackable_attributes(auth_object = nil)
    ["check_in", "check_out", "created_at", "ip_address", "id", "latitude", "longitude"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  # --- REAL-TIME BROADCASTS ---
  
  # 1. When Created: Add to the top of the list
  after_create_commit do
    broadcast_prepend_to "attendance_stream", 
                         target: "attendance_table_body", 
                         partial: "admin/dashboard/attendance_row", 
                         locals: { record: self }
  end

  # 2. When Updated: Replace the row
  after_update_commit do
    # FIX: Changed 'dom_id(self)' to "attendance_#{id}"
    broadcast_replace_to "attendance_stream", 
                         target: "attendance_#{id}", 
                         partial: "admin/dashboard/attendance_row", 
                         locals: { record: self }
  end

  # 3. When Deleted: Remove the row
  after_destroy_commit do
    # FIX: Changed 'dom_id(self)' to "attendance_#{id}"
    broadcast_remove_to "attendance_stream", target: "attendance_#{id}"
  end

  # --- CSV EXPORT LOGIC ---
  def self.to_csv
    attributes = %w{ID User Date Check_In Check_Out IP_Address}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |attendance|
        csv << [
          attendance.id,
          attendance.user.full_name,
          attendance.check_in.strftime("%Y-%m-%d"),
          attendance.check_in.strftime("%H:%M"),
          attendance.check_out&.strftime("%H:%M"),
          attendance.ip_address
        ]
      end
    end
  end

  private

  def check_out_after_check_in
    return if check_out.blank? || check_in.blank?

    if check_out < check_in
      errors.add(:check_out, "must be after the check-in time")
    end
  end
end




# I want the pages of all employees to be responsive in both portrait and landscape mode when they login on the mobile browser. also wherever they visit in the app should be responsive on the browser app