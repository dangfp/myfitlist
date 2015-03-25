class User < ActiveRecord::Base
  has_secure_password validation: false

  validates_presence_of :email
  validates_format_of :email, with: /@/, on: :create
  validates_uniqueness_of :email

  validates_presence_of :password
  validates_length_of :password, in: 6..20

  validates_presence_of :full_name
  validates_length_of :full_name, in: 3..20

  has_many :plannings

  def today_planning
    @today_planning = plannings.where(
        created_at: Date.current.beginning_of_day..Date.current.end_of_day)
    @today_planning.first if @today_planning.count == 1
  end

  def has_today_planning?
    !!today_planning
  end
end