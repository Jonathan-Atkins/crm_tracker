class StageLog < ApplicationRecord
  belongs_to :customer

  validates :from_stage, presence: true , inclusion: { in: Customer.stages.values}
  validates :to_stage, presence: true, inclusion: { in: Customer.stages.values}
end
