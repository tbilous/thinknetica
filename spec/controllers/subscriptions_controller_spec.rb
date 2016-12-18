require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  include_context 'users'
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    subject { post :create, params: { question_id: question.id } }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Subscription, :count) }
    end
    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Subscription, :count) }
    end
  end

  describe 'DELETE #destroy', js: true do
    let!(:subscription) { create(:subscription, user: user, question: question) }
    subject { delete :destroy, params: { id: subscription.id } }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Subscription, :count) }
    end
    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Subscription, :count) }
    end
  end
end
