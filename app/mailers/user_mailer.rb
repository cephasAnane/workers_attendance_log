class UserMailer < ApplicationMailer
    default from: 'notifications@attendancelog.com'

    # Welcome Email (Sent when admin creates a user)
    def welcome_email
        @user = params[:user]
        @password = params[:password] # We pass this so they know what to login with
        mail(to: @user.email, subject: 'Welcome to AttendanceLog - Your Credentials')
    end


    # Leave request update (approved/rejected)
    def leave_status_email
        @leave_request = params[:leave_request]
        @user = @leave_request.user
        mail(to: @user.email, subject: "Leave Request Update: #{@leave_request.status.capitalize}")
    end

    
    # payment notifications
    def payment_email
        @payment = params[:payment]
        @user = @payment.user
        mail(to: @user.email, subject: "You have received a payment.")
    end
end
