class Customer < ApplicationRecord
  #!were defining the stages using enum to enforce consistency
  enum :stage, {
    lead: 0,
    contacted: 1,
    qualified: 2,
    trial_demo: 3,
    closed_won: 4,
    closed_lost: 5
  }, default: :lead

  has_many :stage_logs, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :company, presence: true
  validates :stage, presence: true
end
