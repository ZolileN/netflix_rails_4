FactoryGirl.define do
  factory :video do
    title        Faker::Lorem.word
    description  Faker::Lorem.paragraph(1)
  end
end
