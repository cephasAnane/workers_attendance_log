class LeaveRequest < ApplicationRecord
  belongs_to :user

  enum :leave_type, { sick: 0, vacation: 1, personal: 2, other: 3 }
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :start_date, :end_date, :leave_type, :reason, presence: true
  validate :end_date_after_start_date

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :pending
  end

  def duration
    return 0 if end_date.nil? || start_date.nil?
    (end_date - start_date).to_i + 1
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
