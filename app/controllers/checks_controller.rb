class ChecksController < AuthenticatedController
  def create
    transaction = Transaction.new(transaction_params)
    Checks::Creator.new(transaction).call

    flash[:notice] = t('checks.alerts.success_check')
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.message
  rescue NoMethodError
    flash[:error] = t('checks.alerts.recipient_not_found')
  ensure
    redirect_to bank_account_url(transaction.sender)
  end

  private

  def transaction_params
    params.require(:transaction).permit(:sender_id, :recipient_id, :amount, :amount_currency)
  end

  def bank_account
    @bank_account ||= current_user.bank_accounts.find(params[:transaction][:sender_id])
  end
end
