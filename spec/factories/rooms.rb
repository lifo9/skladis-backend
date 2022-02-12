FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Room #{n}" }
    warehouse { create(:warehouse) }
  end
end
