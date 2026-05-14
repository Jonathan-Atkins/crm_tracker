class StageLog < ApplicationRecord
  belongs_to :customer

  validates :from_stage, presence: true , inclusion: { in: Customer.stages.values}, allow_nil: true
  validates :to_stage, presence: true, inclusion: { in: Customer.stages.values}
end
