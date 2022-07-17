FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    room { create(:room) }
  end
end
