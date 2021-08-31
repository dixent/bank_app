describe ChecksController, type: :controller do
  describe '#create' do
    let(:sender) { create(:bank_account) }
    let(:recipient) { create(:bank_account) }
    let(:params) { { transaction: { sender_id: sender.id, recipient_id: recipient.id } } }

    subject do
      post :create, params: params
    end

    context 'when user is authenticated' do
      shared_examples 'redirect to bank account' do
        it 'redirects to bank account page' do
          expect(subject).to redirect_to(bank_account_url(sender))
        end
      end

      before do
        sign_in sender.user
      end

      context 'when creator service raises validation error' do
        let(:error) { ActiveRecord::RecordInvalid.new }

        before do
          allow_any_instance_of(Checks::Creator).to receive(:call).and_raise(error)
        end

        include_examples 'redirect to bank account'

        it 'returns error message in the flash' do
          subject
          expect(flash[:error]).to eq(error.message)
        end
      end

      context 'when creator service raises no method error' do
        before do
          allow_any_instance_of(Checks::Creator).to receive(:call).and_raise(NoMethodError)
        end

        include_examples 'redirect to bank account'

        it 'returns error message: recipient not found' do
          subject
          expect(flash[:error]).to eq(I18n.t('checks.alerts.recipient_not_found'))
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'redirects to sign_in page' do
        expect(subject).to redirect_to(new_user_session_url)
      end
    end
  end
end
