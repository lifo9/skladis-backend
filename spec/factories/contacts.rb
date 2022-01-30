FactoryBot.define do
  factory :contact do
    first_name { 'First' }
    last_name { 'Last' }
    email { 'test@test.test' }
    phone { '+421900123456' }

    after(:build) do |user|
      user.avatar.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg')),
        filename: 'avatar.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
