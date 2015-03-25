require 'spec_helper'

describe Plan do
  it { should validate_numericality_of(:weight).is_greater_than(0).is_less_than_or_equal_to(200) }
  it { should have_many(:items) }
  it { should belong_to(:user) }

  let(:plan) { Fabricate(:plan)}
  let(:unfinished_item1) { Fabricate(:item, plan: plan, finished: false) }
  let(:unfinished_item2) { Fabricate(:item, plan: plan, finished: false) }
  let(:finished_itme1) { Fabricate(:item, plan: plan, finished: true) }
  let(:finished_itme2) { Fabricate(:item, plan: plan, finished: true) }

  describe "#unfinished_items" do
    it "returns an array for the unfinished items" do
      expect(plan.unfinished_items).to match_array([unfinished_item1, unfinished_item2])
    end
  end

  describe "#finished_items" do
    it "returns an array for the finished items" do
      expect(plan.finished_items).to match_array([finished_itme1, finished_itme2])
    end
  end
end