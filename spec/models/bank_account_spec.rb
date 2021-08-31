describe BankAccount, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:sended_transactions).class_name('Transaction').with_foreign_key('sender_id') }
  end

  describe 'validates' do
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end

  it { is_expected.to monetize(:balance_cents) }

  describe '#transactions' do
    let(:bank_account) { create(:bank_account) }
    let!(:transaction1) { create(:transaction, sender: bank_account) }
    let!(:transaction2) { create(:transaction, sender: bank_account) }
    let!(:transaction3) { create(:transaction, recipient: bank_account) }
    let!(:transaction4) { create(:transaction, recipient: bank_account) }

    subject { bank_account.transactions }

    it 'returns all transactions ordered by created_at and start from last' do
      expect(subject.to_a).to eq(
        [transaction4, transaction3, transaction2, transaction1]
      )
    end
  end
end
