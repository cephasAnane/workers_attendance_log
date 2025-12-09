class Admin::AttendancesController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    def edit
        @attendance = Attendance.find(params[:id])
    end

    def update
        @attendance = Attendance.find(params[:id])

        if @attendance.update(attendance_params)
            redirect_to admin_dashboard_path, notice: "Attendance record updated."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @attendance = Attendance.find(params[:id])
        @attendance.destroy
        redirect_to admin_dashboard_path, notice: "Record deleted."
    end

    private

    def ensure_admin!
        redirect_to root_path, alert: "Access Denied" unless current_user.admin?
    end

    def attendance_params
        params.require(:attendance).permit(:check_in, :check_out, :note)
        params.permit(:latitude, :longitude)
    end
end
