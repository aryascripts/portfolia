require 'rails_helper'

RSpec.describe Holding, type: :model do
  # Association tests
  describe "associations" do
    it { should belong_to(:account) }
  end

  # Validation tests
  describe "validations" do
    it { should validate_presence_of(:symbol) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:average_price).is_greater_than(0) }
    it { should validate_numericality_of(:current_price).is_greater_than(0) }
  end

  # Instance method tests
  describe "#market_value" do
    let(:holding) { create(:holding, quantity: 10, current_price: 50.0) }

    it "calculates the market value correctly" do
      expect(holding.market_value).to eq(500.0)
    end
  end

  describe "#cost_basis" do
    let(:holding) { create(:holding, quantity: 10, average_price: 40.0) }

    it "calculates the cost basis correctly" do
      expect(holding.cost_basis).to eq(400.0)
    end
  end

  describe "#gain_loss" do
    let(:holding) { create(:holding, quantity: 10, average_price: 40.0, current_price: 50.0) }

    it "calculates the gain/loss correctly" do
      expect(holding.gain_loss).to eq(100.0)
    end
  end
end
