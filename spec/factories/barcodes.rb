FactoryBot.define do
  factory :barcode do
    barcode_type { 'EAN' }
    sequence(:barcode_code) { |n| "XYZ#{n}" }
  end
end
