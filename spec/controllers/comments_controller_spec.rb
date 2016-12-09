require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  shared_examples 'comments #create' do |context_name|
    context context_name do
      before { sign_in(user) }

      it { expect { subject }.to change(context.comments, :count).by(1) }

      it_behaves_like 'unauthorized user request' do
        it { expect { subject }.to_not change(context.comments, :count) }
      end

      it_behaves_like 'invalid params', 'empty body', model: Comment do
        let(:form_params) { { body: '' } }
      end
    end
  end

  shared_examples 'comments #destroy' do |context_name|
    context context_name do
      before do
        sign_in(user)
      end

      it { expect { subject }.to change(context.comments, :count).by(-1) }

      it_behaves_like 'unauthorized user destroy' do
        it { expect { subject }.to_not change(context.comments, :count) }
      end
      it_behaves_like 'when user not is owner' do
        it { expect { subject }.to_not change(context.comments, :count) }
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    let(:form_params) { {} }

    let(:params) do
      { comment: attributes_for(:comment).merge(form_params), format: :json }.merge(context_params)
    end

    subject { process :create, method: :post, params: params }

    it_behaves_like 'comments #create', 'question' do
      let(:context_params) { { question_id: question, context: 'question' } }
      let(:context) { question }
    end

    it_behaves_like 'comments #create', 'answer' do
      let(:context_params) { { answer_id: answer, context: 'answer' } }
      let(:context) { answer }
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    let(:params) do
      { id: comment.id, format: :js }
    end

    subject { delete :destroy, params: params }

    it_behaves_like 'comments #destroy', 'question' do
      let!(:comment) { create(:comment, user: user, commentable: question) }
      let(:context_params) { { question_id: question, context: 'question' } }
      let(:context) { question }
    end

    it_behaves_like 'comments #destroy', 'answer' do
      let!(:comment) { create(:comment, user: user, commentable: answer) }
      let(:context_params) { { answer_id: answer, context: 'answer' } }
      let(:context) { answer }
    end
  end
end
