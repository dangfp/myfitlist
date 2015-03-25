require 'spec_helper'

describe User do
  it { should have_secure_password }

  it { should validate_presence_of(:email) }
  it { should allow_value('test@yahoo.cn').for(:email) }
  it { should_not allow_value('yahoo.cn').for(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6).is_at_most(20) }

  it { should validate_presence_of(:full_name) }
  it { should validate_length_of(:full_name).is_at_least(3).is_at_most(20) }

  it { should have_many(:plans) }

  let(:user) { Fabricate(:user) }

  describe "#today_plan" do
    it "returns the plan of today when the user has the today plan" do
      plan = Fabricate(:plan, user_id: user.id)
      expect(user.today_plan).to eq(plan)
    end

    it "returns nil when the user has't the today plan" do
      expect(user.today_plan).to be_nil
    end
  end

  describe "#has_today_plan?" do
    it "returns true when the user has the today plan" do
      plan = Fabricate(:plan, user_id: user.id)
      expect(user.has_today_plan?).to eq(true)
    end

    it "returns false when the user has't the today plan" do
      expect(user.has_today_plan?).to eq(false)
    end
  end
end