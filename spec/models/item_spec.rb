require 'spec_helper'

describe Item do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(1).is_at_most(20) }

  it { should validate_presence_of(:duration) }
  it { should validate_numericality_of(:duration).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(999) }

  it { should validate_presence_of(:result) }
  it { should validate_numericality_of(:result).is_greater_than_or_equal_to(0.1).is_less_than_or_equal_to(999)}

  it { should validate_presence_of(:unit) }
  it { should validate_length_of(:unit).is_at_least(1).is_at_most(6) }
  
  it { should belong_to(:plan) }
end