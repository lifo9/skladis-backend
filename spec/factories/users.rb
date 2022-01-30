FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email-#{n}@test.test" }
    sequence(:first_name) { |n| "First #{n}" }
    sequence(:last_name) { |n| "Last #{n}" }
    phone { "+421900123456" }
    password { 'password' }
    active { true }

    after(:build) do |user|
      user.avatar.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg')),
        filename: 'avatar.jpg',
        content_type: 'image/jpeg'
      )
    end

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
