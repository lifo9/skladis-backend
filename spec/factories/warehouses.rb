FactoryBot.define do
  factory :warehouse do
    sequence(:name) { |n| "Warehouse #{n}" }
    sequence(:street_name) { |n| "Street name #{n}" }
    sequence(:street_number) { |n| "Street number #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:country) { |n| "Country #{n}" }
  end
end
