describe BankAccount, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  it { is_expected.to monetize(:balance_cents) }
end
