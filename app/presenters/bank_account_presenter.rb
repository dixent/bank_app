class BankAccountPresenter
  attr_reader :bank_account

  def initialize(bank_account, page = 0)
    @bank_account = bank_account
    @page = page
  end

  def transactions
    @transactions ||= @bank_account.transactions.includes(sender: :user, recipient: :user).page(@page)
  end

  def transaction
    @transaction ||= @bank_account.sended_transactions.new(amount_currency: @bank_account.balance_currency)
  end
end
