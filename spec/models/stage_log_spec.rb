require 'rails_helper'

RSpec.describe StageLog, type: :model do
  describe "associations" do
    it "belongs to customer" do
      customer = create(:customer)
      stage_log = create(:stage_log, customer:)
      expect(stage_log.customer).to eq(customer)
    end
  end

  describe "validations" do
    it "is valid with customer, from_stage, to_stage" do
      stage_log = build(:stage_log, customer: create(:customer), from_stage: "lead", to_stage: "contacted")
      expect(stage_log).to be_valid
    end

    it "is invalid without from_stage" do
      stage_log = build(:stage_log, from_stage: nil)
      expect(stage_log).not_to be_valid
      expect(stage_log.errors[:from_stage]).to be_present
    end

    it "is invalid without to_stage" do
      stage_log = build(:stage_log, to_stage: nil)
      expect(stage_log).not_to be_valid
      expect(stage_log.errors[:to_stage]).to be_present
    end

    it "only accepts valid stage enum values" do
      customer = create(:customer)
      stage_log = build(:stage_log, customer:)
      stage_log.from_stage = 99
      expect(stage_log).not_to be_valid
      expect(stage_log.errors[:from_stage]).to be_present
    end
  end
end
