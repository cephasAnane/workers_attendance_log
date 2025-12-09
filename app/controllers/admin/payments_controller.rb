class Admin::PaymentsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!
  
    def index
      @month = (params[:month] || Date.current.month).to_i
      @year = (params[:year] || Date.current.year).to_i
      
      @users = User.where(role: :employee).order(:full_name)
      @payments = Payment.where('EXTRACT(MONTH FROM payment_date) = ? AND EXTRACT(YEAR FROM payment_date) = ?', @month, @year)
      @pending_requests = PaymentRequest.pending.includes(:user).order(created_at: :desc)
    end
  
    def create
      @payment = Payment.new(payment_params)
      @payment.status = :paid
      @payment.payment_date = Date.current
      
      if @payment.save
        # SEND EMAIL (Salary Payment)
        UserMailer.with(payment: @payment).payment_email.deliver_later
        
        redirect_to admin_payments_path(month: Date.current.month, year: Date.current.year), notice: "Payment processed."
      else
        redirect_to admin_payments_path, alert: "Failed to process payment."
      end
    end
  
    def update_request
      @request = PaymentRequest.find(params[:id])
      status = params[:status] # 'approved' or 'rejected'
  
      if status == 'approved'
        ActiveRecord::Base.transaction do
          # 1. Mark request as approved
          @request.update!(status: :approved)
          
          # 2. Create the actual Payment record AND assign it to variable 'payment'
          payment = Payment.create!(
            user: @request.user,
            amount: @request.amount,
            payment_date: Date.current,
            status: :paid,
            note: "Advance Request: #{@request.reason}",
            month: "#{Date.current.month}/#{Date.current.year}"
          )
  
          # 3. NOW 'payment' exists, so we can email it
          UserMailer.with(payment: payment).payment_email.deliver_later
        end
        msg = "Request approved and payment issued."
      else
        @request.update(status: :rejected)
        msg = "Request rejected."
      end
  
      redirect_to admin_payments_path, notice: msg
    rescue ActiveRecord::RecordInvalid
      redirect_to admin_payments_path, alert: "Error processing request."
    end
  
    private
  
    def payment_params
      params.require(:payment).permit(:user_id, :amount, :note, :month)
    end
  
    def ensure_admin!
      redirect_to root_path, alert: "Access Denied" unless current_user.admin?
    end
  end