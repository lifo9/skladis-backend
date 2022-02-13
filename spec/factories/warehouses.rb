FactoryBot.define do
  factory :warehouse do
    sequence(:name) { |n| "Warehouse #{n}" }
    sequence(:street_name) { |n| "Street name #{n}" }
    sequence(:street_number) { |n| "Street number #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:zip) { |n| "123 #{n}" }
    sequence(:country) { |n| "Country #{n}" }
    sequence(:coordinates) { |n| [n, n + 1] }
  end
end
