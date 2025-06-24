require 'rails_helper'

RSpec.describe Account, type: :model do
  # Association tests
  describe "associations" do
    it { should have_many(:account_balances).dependent(:destroy) }
    it { should have_many(:holdings).dependent(:destroy) }
  end

  # Validation tests
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:account_type) }
    it { should validate_presence_of(:currency) }

    it "validates account_type inclusion" do
      should validate_inclusion_of(:account_type).in_array(Account::ACCOUNT_TYPES)
    end
  end

  # Instance method tests
  describe "#latest_balance" do
    let(:account) { create(:account) }
    let!(:old_balance) { create(:account_balance, account: account, recorded_at: 2.days.ago) }
    let!(:new_balance) { create(:account_balance, account: account, recorded_at: 1.day.ago) }

    it "returns the most recent balance" do
      expect(account.latest_balance).to eq(new_balance)
    end

    it "returns nil when no balances exist" do
      account_without_balances = create(:account)
      expect(account_without_balances.latest_balance).to be_nil
    end
  end
end
