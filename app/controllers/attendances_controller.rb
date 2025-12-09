class AttendancesController < ApplicationController
  def index
    @attendances = policy_scope(Attendance).order(created_at: :desc).page(params[:page])

    @active_attendance = current_user.attendances.find_by(check_out: nil)
  end

  def create
    if current_user.attendances.where(check_out: nil).exists?
      redirect_to attendances_path, alert: "You are already checked in!"
      return
    end

    @attendance = current_user.attendances.build(attendance_params)
    @attendance.check_in = Time.current

    if @attendance.save 
      redirect_to attendances_path, notice: "Checked in successfully at #{l(@attendance.check_in, format: :short)}"
    else
      redirect_to attendances_path, alert: "Could  not check in."
    end
end

def update
  @attendance = current_user.attendances.find(params[:id])
  authorize @attendance 

  if @attendance.update(check_out: Time.current)
    redirect_to attendances_path, notice: "Checked out successfully at #{l(@attendance.check_out, format: :short)}"
  else
    redirect_to attendances_path, alert: "Could not check out."
  end
end

private 

  def attendance_params
    params.permit(:latitude, :longtitude)
  end
end
