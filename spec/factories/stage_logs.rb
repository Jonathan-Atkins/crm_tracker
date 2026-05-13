FactoryBot.define do
  factory :stage_log do
    customer { nil }
    from_stage { 1 }
    to_stage { 1 }
  end
end
