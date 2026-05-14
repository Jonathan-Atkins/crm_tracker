require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    it "is valid with name, email, company, stage" do
      customer = build(:customer, name: "John Doe", email: "john@example.com", company: "ACME", stage: "lead")
      expect(customer).to be_valid
    end

    it "is invalid without name" do
      customer = build(:customer, name: nil)
      expect(customer).not_to be_valid
      expect(customer.errors[:name]).to be_present
    end

    it "is invalid without email" do
      customer = build(:customer, email: nil)
      expect(customer).not_to be_valid
      expect(customer.errors[:email]).to be_present
    end

    it "is invalid without company" do
      customer = build(:customer, company: nil)
      expect(customer).not_to be_valid
      expect(customer.errors[:company]).to be_present
    end
  end

  describe "associations" do
    it "has many stage_logs" do
      customer = create(:customer)
      expect(customer.stage_logs).to be_empty

      create(:stage_log, customer:)
      expect(customer.stage_logs.count).to eq(1)
    end
  end

  describe "enums" do
    it "defines valid enum stages" do
      customer = build(:customer)
      expect(Customer.stages.keys).to include("lead", "contacted", "qualified", "trial_demo", "closed_won", "closed_lost")
    end
  end
end
