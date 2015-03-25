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

  it { should have_many(:plannings) }

  let(:user) { Fabricate(:user) }

  describe "#today_planning" do
    it "returns the planning of today when the user has the today planning" do
      planning = Fabricate(:planning, user_id: user.id)
      expect(user.today_planning).to eq(planning)
    end

    it "returns nil when the user has't the today planning" do
      expect(user.today_planning).to be_nil
    end
  end

  describe "#has_today_planning?" do
    it "returns true when the user has the today planning" do
      planning = Fabricate(:planning, user_id: user.id)
      expect(user.has_today_planning?).to eq(true)
    end

    it "returns false when the user has't the today planning" do
      expect(user.has_today_planning?).to eq(false)
    end
  end
end