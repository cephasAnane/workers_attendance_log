class PayslipPdf < Prawn::Document
    def initialize(payment)
        super()
        @payment = payment
        header
        payment_details
        footer
    end

    def header
        text "AttendanceLog System", size: 18, style: :bold, align: :center
        text "Official Payslip", size: 14, align: :center
        move_down 20
        stroke_horizontal_rule
        move_down 20
    end

    def payment_details
        text "Employee Details", style: :bold, size: 12
        move_down 5
        text "Name: #{@payment.user.full_name}"
        text "Email: #{@payment.user.email}"
        text "Department: #{@payment.user.department&.name || 'N/A'}"

        move_down 30
        text "Payment Information", style: :bold, size: 12
        move_down 10

        data = [
            ["Receipt ID", "PAY-#{@payment.id.to_s.rjust(6, '0')}"],
            ["Date", @payment.payment_date.strftime("%B %d, %Y")],
            ["Description", @payment.note.present? ? @payment.note : "Salary Payment"],
            ["Amount", "$#{@payment.amount}"]
        ]

        table(data) do
            cells.padding = 12
            cells.borders = [:bottom]
            row(3).font_style = :bold
            rows(3).size = 14
            columns(1).align = :right
        end
    end


    def footer
        move_down 50
        text "Authorized Signature", align: :right
        move_down 30
        stroke_horizontal_rule
        move_down 5
        text "Generated on #{Date.current.strftime('%Y-%m-%d')}", size: 8, align: :center, color: "888888"
    end
end