class CreditSender
  def initialize(recipient, amount)
    @amount = amount
    @bank_account = recipient
    @credit_bank = BankAccount.bank
  end

  def call
    ActiveRecord::Base.transaction do
      @credit_bank.update!(balance: @credit_bank.balance - monetize_amount_by_default)
      @bank_account.update!(balance: @bank_account.balance + monetize_amount_by_default)
      @bank_account.recipient_transactions.create!(
        amount: @amount, sender: @credit_bank, amount_currency: @credit_bank.balance_currency
      )
    end
  end

  def monetize_amount_by_default
    @monetize_amount_by_default ||= Money.new(@amount * 100, 'USD')
  end
end
