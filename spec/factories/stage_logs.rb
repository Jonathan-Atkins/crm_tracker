FactoryBot.define do
  factory :stage_log do
    association :customer
    from_stage { Customer.stages["lead"] }
    to_stage { Customer.stages["contacted"] }
  end
end
