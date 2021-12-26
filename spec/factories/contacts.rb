FactoryBot.define do
  factory :contact do
    first_name { 'First' }
    last_name { 'Last' }
    email { 'test@test.test' }
    phone { '+421900123456' }
  end
end
