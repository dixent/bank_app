class BankAccount < ApplicationRecord
  BANK_EMAIL = 'bank@bank.com'.freeze

  belongs_to :user
  has_many :sended_transactions, class_name: 'Transaction', foreign_key: 'sender_id'
  has_many :recipient_transactions, class_name: 'Transaction', foreign_key: 'recipient_id'

  monetize :balance_cents, numericality: { greater_than_or_equal_to: 0 }

  class << self
    def bank
      User.find_by(email: BANK_EMAIL).bank_accounts.first
    end
  end

  def transactions
    @transactions ||= Transaction.where(sender_id: id).or(Transaction.where(recipient_id: id)).order(created_at: :desc)
  end
end
