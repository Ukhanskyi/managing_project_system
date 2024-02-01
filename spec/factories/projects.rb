# Projects factory
FactoryBot.define do
  factory :project do
    name        { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraphs(number: rand(2..8)).join("\n") }

    association :user, factory: :user
  end
end
