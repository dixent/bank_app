describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:sender).class_name('BankAccount') }
    it { should belong_to(:recipient).class_name('BankAccount') }
  end

  describe 'validations' do
    context 'if sender and recipient are the same' do
      let(:bank_account) { create(:bank_account) }
      let(:transaction) { build(:transaction, sender: bank_account, recipient: bank_account) }

      it 'returns error message' do
        expect(transaction.valid?).to eq(false)
        expect(transaction.errors.first.message).to eq(I18n.t('errors.sender_equal_recipient'))
      end
    end

    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  it { is_expected.to monetize(:amount_cents) }
end
