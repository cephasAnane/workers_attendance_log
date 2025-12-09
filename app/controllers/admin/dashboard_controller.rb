class Admin::DashboardController < ApplicationController
  before_action :ensure_admin!

  def index
    # 1. Active Users
    @active_users = User.joins(:attendances).where(attendances: { check_out: nil }).distinct
    @total_employees = User.where(role: :employee).count
    @pending_leaves = LeaveRequest.pending.count
    @today_attendance = Attendance.where(check_in: Time.current.beginning_of_day..Time.current.end_of_day).count

    # 2. Search Logic
    @q = Attendance.joins(:user).order(created_at: :desc).ransack(params[:q])
    @attendances = @q.result(distinct: true).page(params[:page]).per(10) # Limit to 10 per page for cleanliness

    # 3. Export Logic
    respond_to do |format|
      format.html
      format.csv { 
        send_data @attendances.to_csv, filename: "attendance-#{Date.today}.csv" 
      }
    end
  end

  private

  def ensure_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "Access Denied. Admins only."
    end
  end
end