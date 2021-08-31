FactoryBot.define do
  factory :transaction do
    amount { rand(1000) }
    sender { create(:bank_account) }
    recipient { create(:bank_account) }
  end
end
