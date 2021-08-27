class Users::CreditSender
  def initialize(user, amount)
    @user = user
    @amount = amount
    @bank_account = user.bank_accounts.first
  end

  def call
    @bank_account.update(balance_cents: @bank_account.balance_cents + @amount)
  end
end
