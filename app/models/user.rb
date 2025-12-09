class User < ApplicationRecord
  has_paper_trail
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  belongs_to :department, optional: true
  has_many :attendances, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :payment_requests, dependent: :destroy
  has_one_attached :profile_photo

  enum :role, { employee: 0, admin: 1 }

  def hours_worked_in(month, year)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    monthly_attendances = attendances.where(check_in: start_date.beginning_of_day..end_date.end_of_day)

    total_seconds = 0
    monthly_attendances.each do |att|
      if att.check_out.present?
        total_seconds += (att.check_out - att.check_in)
      end
    end

    (total_seconds / 3600).round(2)
  end

  # Helper: calculate estimated salary
  def estimated_salary_for(month, year)
    hours = hours_worked_in(month, year)
    rate = hourly_rate || 0.0 # Default to 0 if not set
    (hours * rate).round(2)
  end

  def avatar_thumbnail
    if profile_photo.attached?
      profile_photo
    else
      "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?d=mp"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email", "full_name", "role", "department_id", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["attendances", "department"]
  end
  

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :employee
  end

  def display_name
    full_name.presence || email
  end
end
