class StageLog < ApplicationRecord
  belongs_to :customer

  validates :from_stage, presence: true
  validates :to_stage, presence: true
end
