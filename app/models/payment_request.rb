class PaymentRequest < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :amount, :reason, presence: true

  after_initialize :set_default_status, if: :new_record?

  
  def set_default_status
    self.status ||= :pending
  end
end
