require 'rails_helper'
require_relative 'concerns/voted'

RSpec.describe AnswersController, type: :controller do
  include_context 'users'

  let!(:question) { create(:question, user_id: user.id) }

  describe 'votes' do
    it_behaves_like 'voted'
  end

  # let(:question) { user.questions.create(title: 'a' * 61, body: 'b' * 120) }

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST create' do
    let(:form_params) { {} }

    let(:params) do
      { answer: attributes_for(:answer).merge(form_params), question_id: question.id, format: :js }
    end

    subject { process :create, method: :post, params: params }

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Answer, :count).by(1) }

      it_behaves_like 'invalid params js', 'empty body', model: Comment do
        let(:form_params) { { body: '' } }
      end
    end

    it_behaves_like 'unauthorized user request' do
      it { expect { subject }.to_not change(Answer, :count) }
    end
  end

  describe 'PATCH update' do
    let!(:answer) { create(:answer, question: question, user_id: user.id) }
    new_param = ('z' * 6)

    let(:params) do
      {
        answer: { body: new_param },
        id: answer.id,
        format: :js
      }
    end

    subject do
      process :update, method: :post, params: params
      answer.reload
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      it { expect(answer.body).to eql new_param }
      it { expect(response).to render_template :update }
    end

    it_behaves_like 'when user is unauthorized' do
      before { subject }
      it { expect(answer.body).to_not eql new_param }
    end

    it_behaves_like 'when user not is owner' do
      before { subject }
      it { expect(answer.body).to_not eql new_param }
    end
  end

  describe 'DELETE #destroy' do
    let(:params) do
      {
        id: answer.id,
        format: :js
      }
    end
    let!(:answer) { create(:answer, question: question, user_id: user.id) }

    subject { delete :destroy, params: params }

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change { Answer.count } }
      it { expect(subject).to have_http_status(200) }
    end

    it_behaves_like 'unauthorized user request' do
      it { expect { subject }.to_not change(Answer, :count) }
    end

    it_behaves_like 'when user not is owner' do
      it { expect { subject }.to_not change { Answer.count } }
      it { expect(subject).to have_http_status(403) }
    end
  end

  describe 'PATCH #make_best' do
    let(:params) do
      {
        id: answer.id,
        format: :js
      }
    end

    let(:question) { create(:question, user_id: user.id) }
    let!(:answer) { create(:answer, question: question, user_id: john.id) }
    let!(:best_answer) { create(:answer, user: user, question: question, best: true) }

    subject do
      patch :assign_best, params: params
      answer.reload
      best_answer.reload
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      it { expect(answer).to be_best }
      it { expect(best_answer).to_not be_best }
      it { expect(response).to render_template 'answers/assign_best' }
    end

    it_behaves_like 'when user is unauthorized' do
      before { subject }
      it { expect(answer).to_not be_best }
      it { expect(response).to_not render_template 'answers/assign_best' }
    end

    it_behaves_like 'when user not is owner' do
      before { subject }
      it { expect(answer).to_not be_best }
      it { expect(response).to_not render_template 'answers/assign_best' }
    end
  end
end
