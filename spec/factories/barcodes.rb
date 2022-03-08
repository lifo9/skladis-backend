FactoryBot.define do
  factory :barcode do
    type { 'EAN' }
    sequence(:code) { |n| "XYZ#{n}" }
  end
end
