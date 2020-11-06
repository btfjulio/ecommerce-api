FactoryBot.define do
  factory :game do
    mode { %i(pvp pve both).sample }
    release_date { "2020-11-06 09:38:01" }
    developer { Faker::Company.name }
    system_requirement
  end
end
