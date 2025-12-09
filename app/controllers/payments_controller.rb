class PaymentsController < ApplicationController
  def index
    @payments = current_user.payments.order(payment_date: :desc)
    @requests = current_user.payment_requests.order(created_at: :desc)
  end

  def new
    @payment_request = current_user.payment_requests.build
  end

  def show
    @payment = Payment.find(params[:id])

    unless @payment.user == current_user
      redirect_to payments_path, alert: "Access Denied"
      return
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = PayslipPdf.new(@payment)
        send_data pdf.render,
          filename: "payslip_#{@payment.id}.pdf",
          type: "appilcation/pdf",
          disposition: "inline" # Use "attachment" to force download, "inline" to view in browser
      end
    end
  end

  def create
    @payment_request = current_user.payment_requests.build(payment_request_params)
    
    if @payment_request.save
      redirect_to payments_path, notice: "Payment request sent to admin."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:amount, :reason)
  end
end
