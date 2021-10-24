FactoryBot.define do
	factory :user do
		sequence(:email) { |n| "email-#{n}@test.test" }
		password { 'password' }
	end
end
