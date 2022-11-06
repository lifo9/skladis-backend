FactoryBot.define do
  factory :vendor do
    sequence(:name) { |n| "Vendor #{n}" }
    sequence(:url) { |n| "https://test-vendor-#{n}.skladis.com" }

    after(:build) do |vendor|
      vendor.logo.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg')),
        filename: 'avatar.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
