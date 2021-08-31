class IdenticalBankAccountsValidator < ActiveModel::Validator
  def validate(record)
    return unless record.sender_id == record.recipient_id

    record.errors.add(:sender, I18n.t('errors.sender_equal_recipient'))
  end
end
