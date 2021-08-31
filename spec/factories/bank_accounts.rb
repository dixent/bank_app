FactoryBot.define do
  factory :bank_account do
    balance { rand(1000) }
    user { create(:user) }
  end
end
