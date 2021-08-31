ActiveRecord::Base.transaction do
  bank1 = User.create!(email: 'bank@bank.com', password: 'useruser', password_confirmation: 'useruser')
  bank1.bank_accounts.first.update(balance: 1_000_000)

  user1 = User.create!(email: 'user1@user.com', password: 'useruser', password_confirmation: 'useruser')
  user2 = User.create!(email: 'user2@user.com', password: 'useruser', password_confirmation: 'useruser')

  bank_account1 = user1.bank_accounts.first
  bank_account2 = user2.bank_accounts.first

  CreditSender.new(bank_account1, 1_000_0).call
  CreditSender.new(bank_account2, 1_000_0).call

  50.times do
    Checks::Creator.new(Transaction.new(sender: bank_account1, recipient: bank_account2, amount: rand(1..15))).call
    Checks::Creator.new(Transaction.new(sender: bank_account2, recipient: bank_account1, amount: rand(1..15))).call
  end
end
