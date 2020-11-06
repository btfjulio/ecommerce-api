FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    sequence(:operational_system) { |n| Faker::Computer.os }
    sequence(:storage) { "500GB" }
    sequence(:processor) { "AMD Ryzen 7" }
    sequence(:memory) { "2GB" }
    sequence(:video_board) { "GeForce X" }
  end
end
