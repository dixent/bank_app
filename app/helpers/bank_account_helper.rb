module BankAccountHelper
  def set_bank_account(transaction_bank_account, bank_account)
    if transaction_bank_account == bank_account
      t('.yourself')
    elsif transaction_bank_account == BankAccount.bank
      t('bank')
    else
      transaction_bank_account.user.email
    end
  end
end
