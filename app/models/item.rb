class Item < ActiveRecord::Base
  validates_presence_of :name, :duration, :result, :unit
  validates_length_of :name, in: 1..20
  validates_numericality_of :duration, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 999
  validates_numericality_of :result, greater_than_or_equal_to: 0.1, less_than_or_equal_to: 999
  validates_length_of :unit, in: 1..6

  belongs_to :plan
end