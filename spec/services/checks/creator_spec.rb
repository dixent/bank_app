describe Checks::Creator do
  let(:sender) { create(:bank_account, balance: 1000) }
  let(:recipient) { create(:bank_account, balance: 500) }
  let(:amount) { 250 }
  let(:transaction) do
    build(:transaction,
          sender: sender,
          recipient: recipient,
          amount: amount)
  end

  subject { described_class.new(transaction).call }

  shared_examples 'failed validation' do
    it 'returns error with message' do
      expect { subject }.to raise_error(validation_error)
    end
  end

  context "sender doesn't exist" do
    let(:sender) { nil }

    it 'returns NoMethodError' do
      expect { subject }.to raise_error(NoMethodError)
    end
  end

  context 'sender exists' do
    context "recipient doesn't exist" do
      let(:recipient) { nil }

      it 'returns NoMethodError' do
        expect { subject }.to raise_error(NoMethodError)
      end
    end

    context 'recipient exists' do
      let(:validation_error) { ActiveRecord::RecordInvalid.new }

      context 'sender updating was failed' do
        before do
          allow(sender).to receive(:update!).and_raise(validation_error)
        end

        include_examples 'failed validation'
      end

      context 'sender updated successfully' do
        context 'recipient updating was failed' do
          before do
            allow(recipient).to receive(:update!).and_raise(validation_error)
          end

          include_examples 'failed validation'
        end

        context 'recipient updated successfully' do
          context 'transaction saving was failed' do
            before do
              allow(transaction).to receive(:save!).and_raise(validation_error)
            end

            include_examples 'failed validation'
          end

          context 'transaction saved successfully' do
            it "reduces sender's balance by amount" do
              expect { subject }.to change { sender.reload.balance.to_i }.from(1000).to(750)
            end

            it "increases recipient's balance by amount" do
              expect { subject }.to change { recipient.reload.balance.to_i }.from(500).to(750)
            end

            it 'saves transaction with initial parameters' do
              expect { subject }.to change { Transaction.count }.from(0).to(1)
              created_transaction = Transaction.first
              expect(transaction.sender).to eq(created_transaction.sender)
              expect(transaction.recipient).to eq(created_transaction.recipient)
              expect(transaction.amount).to eq(created_transaction.amount)
            end
          end
        end
      end
    end
  end
end
