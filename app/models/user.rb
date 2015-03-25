class User < ActiveRecord::Base
  has_secure_password validation: false

  validates_presence_of :email
  validates_format_of :email, with: /@/, on: :create
  validates_uniqueness_of :email

  validates_presence_of :password
  validates_length_of :password, in: 6..20

  validates_presence_of :full_name
  validates_length_of :full_name, in: 3..20

  has_many :plans

  def today_plan
    @today_plan = plans.where(
        created_at: Date.current.beginning_of_day..Date.current.end_of_day)
    @today_plan.first if @today_plan.count == 1
  end

  def has_today_plan?
    !!today_plan
  end
end