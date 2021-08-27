FactoryBot.define do
  factory :user do
    sequence(:email) { "user#{_1}@user.com" }
    password { 'useruser' }
    password_confirmation { 'useruser' }
  end
end
