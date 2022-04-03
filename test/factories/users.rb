FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { "0123456789" }
  end
end
