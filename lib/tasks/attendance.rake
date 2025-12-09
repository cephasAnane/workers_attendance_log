namespace :attendance do
    desc "Auto-checkout employees who forgot to clock out"
    task auto_checkout: :environment do
        puts "Starting Auto-Checkout..."

        # find all active attendances (check_out is nil)
        active_records = Attendance.where(check_out: nil)

        active_records.each do |record|
            auto_time = record.check_in.end_of_day

            record.update(check_out: auto_time, note: "Auto-checked out by system")
            puts " - Checked out #{record.user.full_name} at #{auto_time}"
        end

        puts "Finished. #{active_records.count} records updated."
    end
end