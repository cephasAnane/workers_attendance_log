class Payment < ApplicationRecord
  has_paper_trail
  
  belongs_to :user

  enum :status, { pending: 0, paid: 1 }

  validates :amount, :payment_date, presence: true
end
