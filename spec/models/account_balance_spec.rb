require 'rails_helper'

RSpec.describe AccountBalance, type: :model do
  # Association tests
  describe "associations" do
    it { should belong_to(:account) }
  end

  # Validation tests
  describe "validations" do
    it { should validate_presence_of(:balance) }
    it { should validate_presence_of(:recorded_at) }
    it { should validate_numericality_of(:balance) }
  end

  # Scope tests
  describe "scopes" do
    let(:account) { create(:account) }
    let!(:old_balance) { create(:account_balance, account: account, recorded_at: 2.days.ago) }
    let!(:new_balance) { create(:account_balance, account: account, recorded_at: 1.day.ago) }

    describe ".most_recent" do
      it "returns balances ordered by recorded_at desc" do
        expect(AccountBalance.most_recent).to eq([new_balance, old_balance])
      end
    end
  end
end
