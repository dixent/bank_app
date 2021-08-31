class Checks::Creator
  def initialize(transaction)
    @transaction = transaction
  end

  def call
    @sender = @transaction.sender
    @recipient = @transaction.recipient

    ActiveRecord::Base.transaction do
      @sender.update!(balance: @sender.balance - @transaction.amount)
      @recipient.update!(balance: @recipient.balance + @transaction.amount)
      @transaction.save!
    end

    @transaction
  end
end
