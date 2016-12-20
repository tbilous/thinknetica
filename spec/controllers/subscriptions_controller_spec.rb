require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  include_context 'users'

  describe 'POST #create' do
    let!(:question) { create(:question, user: john) }
    subject { post :create, params: { question_id: question.id, format: :js } }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Subscription, :count) }
    end
    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Subscription, :count) }
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question, user: user) }
    let(:subscription) { Subscription.where(question: question, user: user) }
    subject { delete :destroy, params: { id: subscription.ids, format: :js } }

    it_behaves_like 'when user is unauthorized' do
      it do
        subscription
        expect { subject }.to_not change(Subscription, :count)
      end
    end
    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Subscription, :count) }
    end
  end
end
