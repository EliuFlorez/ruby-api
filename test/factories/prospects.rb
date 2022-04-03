FactoryBot.define do
  factory :prospect do
    user
    crm
    entity { "crm" }
    name { Faker::Name.name }
    profile_id { 1 }
    status { false }
  end
end
