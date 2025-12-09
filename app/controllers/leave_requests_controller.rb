class LeaveRequestsController < ApplicationController
    def index
        @leave_requests = current_user.leave_requests.order(created_at: :desc)
    end

    def new
        @leave_request = current_user.leave_requests.build
    end

    def create
        @leave_request = current_user.leave_requests.build(leave_request_params)

        if @leave_request.save
            redirect_to leave_requests_path, notice: "Leave request submitted for approval."
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

    def leave_request_params
        params.require(:leave_request).permit(:start_date, :end_date, :leave_type, :reason)
    end
end