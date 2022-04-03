FactoryBot.define do
  factory :crm do
    user
    name { Faker::Name.name }
    entity { "crm" }
    oauth { "xxxxx" }
    status { false }
  end
end
