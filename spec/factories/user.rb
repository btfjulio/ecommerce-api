FactoryBot.define do
  factory :user do
    sequence(:name) { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    sequence(:password) { "123456" }
    sequence(:password_confimation) { "123456" }
    sequence(:profile) { %i(admin client).sample }
  end
end