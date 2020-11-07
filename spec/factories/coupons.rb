FactoryBot.define do
  factory :coupon do
    code { Faker::Commerce.unique }
    status { %i(active inactive).sample }
    discount_value { "9.99" }
    due_date { "2020-11-07 10:58:09" }
  end
end
