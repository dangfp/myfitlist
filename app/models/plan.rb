class Plan < ActiveRecord::Base
  validates_numericality_of :weight, greater_than: 0, less_than_or_equal_to: 200

  has_many :items

  belongs_to :user

  def unfinished_items
    items.where(finished: false)
  end

  def finished_items
    items.where(finished: true)
  end
end