class BankAccountsController < AuthenticatedController
  def show
    @presenter = BankAccountPresenter.new(current_user.bank_accounts.first, params[:page])
  end
end
