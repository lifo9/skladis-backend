FactoryBot.define do
  factory :supplier do
    sequence(:name) { |n| "Supplier #{n}" }
    sequence(:ico) { |n| "54321#{n}" }
    sequence(:dic) { |n| "12345#{n}" }
    sequence(:ic_dph) { |n| "SK12345#{n}" }
    sequence(:url) { |n| "https://skladis.com/supplier-url/#{n}" }
    address { create(:address) }
    contact { create(:contact) }
  end
end
