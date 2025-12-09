class Admin::LeaveRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    def index
        # Show pending first, then recent history
        @leave_requests = LeaveRequest.order(status: :asc, created_at: :desc)
    end

    def update
        @leave_request = LeaveRequest.find(params[:id])

        # We expect params like: { status: 'approved' }
        if @leave_request.update(leave_params)

            UserMailer.with(leave_request: @leave_request).leave_status_email.deliver_later

            redirect_to admin_leave_requests_path, notice: "Request updated and employee notified."
        else
            redirect_to admin_leave_requests_path, alert: "Something went wrong."
        end
    end

    private
    
    def leave_params
        params.require(:leave_request).permit(:status)
    end

    def ensure_admin!
        redirect_to root_path, alert: "Access Denied" unless current_user.admin?
    end
end