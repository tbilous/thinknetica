require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  include_context 'users'

  describe 'POST #create' do
    let(:question) { create(:question, user: user) }
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
    let!(:subscription) { create(:subscription, user: user, question: question) }
    subject { delete :destroy, params: { id: subscription.id, format: :js } }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Subscription, :count) }
    end
    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Subscription, :count) }
    end
  end
end
