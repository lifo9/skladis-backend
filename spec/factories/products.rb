FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    sequence(:order_code) { |n| "ORDER_CODE_#{n}" }
    barcode { create(:barcode) }
    pieces_ideal { 10 }
    pieces_critical { 5 }

    after(:build) do |product|
      product.images.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg')),
        filename: 'avatar.jpg',
        content_type: 'image/jpeg'
      )
    end

    trait :with_supplier do
      after(:create) do |product|
        product.suppliers << FactoryBot.create(:supplier)
      end
    end
  end
end
