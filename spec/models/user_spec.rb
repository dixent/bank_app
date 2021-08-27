describe User, type: :model do
  describe 'associations' do
    it { should have_many(:bank_accounts).dependent(:destroy) }
  end

  describe '#crete_bank_account' do
    it 'creates default bank account for user after commit' do
      user = build(:user)
      expect(user.bank_accounts.blank?).to eq(true)
      user.save!
      expect(user.bank_accounts.blank?).to eq(false)
    end
  end
end
