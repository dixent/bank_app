describe Users::CreditSender do
  let(:user) { create(:user) }
  let(:bank_account) { user.bank_accounts.first }
  let(:current_amount) { 50 }
  let(:amount) { 100 }

  subject { described_class.new(user, amount).call }

  it 'adds amount to first user bank account' do
    bank_account.update(balance_cents: current_amount)
    expect { subject }.to change { bank_account.reload.balance_cents }.from(current_amount).to(current_amount + amount)
  end
end
