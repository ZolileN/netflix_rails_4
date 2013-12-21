FactoryGirl.define do
  factory :user do
    email                  Faker::Internet.email
    full_name              Faker::Name.name
    password               "foobar"
    password_confirmation  "foobar"
  end
end
