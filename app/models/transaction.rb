class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'BankAccount'
  belongs_to :recipient, class_name: 'BankAccount'

  validates_with IdenticalBankAccountsValidator

  monetize :amount_cents, numericality: { greater_than: 0 }
end
