FactoryBot.define do
  factory :user do
    email_address { "admin@test.com" }
    password { "password" }
  end
end
