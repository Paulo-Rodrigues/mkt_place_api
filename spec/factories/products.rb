FactoryBot.define do
  factory :product do
    sequence(:title) { |i| "MyProduct#{i}" }
    price { "9.99" }
    published { false }
    user
  end
end
