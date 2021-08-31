describe BankAccountPresenter do
  let(:bank_account) { create(:bank_account) }

  describe '#transactions' do
    let(:transactions) { create_list(:transaction, 50) }
    let(:page) { 2 }

    subject { described_class.new(bank_account, page).transactions }

    it 'returns 25 transactions by page' do
      expect(subject).to match_array(Transaction.last(25))
    end
  end

  describe '#transaction' do
    subject { described_class.new(bank_account).transaction }

    it 'returns initialized transaction for current bank account' do
      bank_account_paramenters = [bank_account.balance_currency, bank_account.id]
      expect(subject.attributes.values && bank_account_paramenters).to match_array(bank_account_paramenters)
    end
  end
end
