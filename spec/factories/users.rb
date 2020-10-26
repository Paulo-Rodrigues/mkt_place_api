FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "test#{i}@email.com" }
    password { 'password' }
  end
end
