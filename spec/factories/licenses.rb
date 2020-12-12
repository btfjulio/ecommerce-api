FactoryBot.define do
  factory :license do
    key { Faker::Alphanumeric.alphanumeric(number: 20) }
    game
    user
  end
end
