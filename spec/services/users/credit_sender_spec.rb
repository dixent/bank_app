describe CreditSender do
  let(:recipient) { create(:bank_account, balance: 0) }
  let(:amount) { 100 }
  let(:credit_bank) { create(:user, email: BankAccount::BANK_EMAIL).bank_accounts.first }

  subject { described_class.new(recipient, amount).call }

  before do
    credit_bank.update(balance: 1_000_000)
  end

  shared_examples 'failed validation' do
    it 'returns error with message' do
      expect { subject }.to raise_error(validation_error)
    end
  end

  let(:validation_error) { ActiveRecord::RecordInvalid.new }

  context 'credit_bank updating was failed' do
    before do
      allow(BankAccount).to receive(:bank).and_return(credit_bank)
      allow(credit_bank).to receive(:update!).and_raise(validation_error)
    end

    include_examples 'failed validation'
  end

  context 'credit_bank updated successfully' do
    context 'recipient updating was failed' do
      before do
        allow(recipient).to receive(:update!).and_raise(validation_error)
      end

      include_examples 'failed validation'
    end

    context 'recipient updated successfully' do
      context 'transaction creating was failed' do
        before do
          allow_any_instance_of(Transaction).to receive(:save!).and_raise(validation_error)
        end

        include_examples 'failed validation'
      end

      context 'transaction saved successfully' do
        it "reduces credit bank's balance by amount" do
          expect { subject }.to change { credit_bank.reload.balance.to_i }.from(1_000_000).to(999_900)
        end

        it "increases recipient's balance by amount" do
          expect { subject }.to change { recipient.reload.balance.to_i }.from(0).to(100)
        end

        it 'creates transaction with bank parameters' do
          expect { subject }.to change { Transaction.count }.from(0).to(1)
          created_transaction = Transaction.first
          expect(credit_bank).to eq(created_transaction.sender)
          expect(recipient).to eq(created_transaction.recipient)
          expect(amount).to eq(created_transaction.amount.to_i)
          expect(credit_bank.balance_currency).to eq(created_transaction.amount_currency)
        end
      end
    end
  end
end
