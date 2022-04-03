FactoryBot.define do
  factory :property do
    prospect
    field_name { Faker::Name.name }
    field_value { "Value" }
  end
end
