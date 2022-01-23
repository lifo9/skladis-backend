FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email-#{n}@test.test" }
    sequence(:first_name) { |n| "First #{n}" }
    sequence(:last_name) { |n| "Last #{n}" }
    phone { "+421900123456" }
    password { 'password' }
    active { true }

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
