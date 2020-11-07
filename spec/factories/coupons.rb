FactoryBot.define do
  factory :coupon do
    code { Faker::Commerce.unique }
    status { %i(active inactive).sample }
    discount_value { range: 5.0..9.9 }
    due_date { "2020-11-07 10:58:09" }
  end
end
