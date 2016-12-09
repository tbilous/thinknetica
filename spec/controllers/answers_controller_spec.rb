require 'rails_helper'
require_relative 'concerns/voted'

RSpec.describe AnswersController, type: :controller do
  include_context 'users'

  # it_behaves_like 'voted'

  shared_examples '#create' do |context_name|
    context context_name do
      before { sign_in(user) }

      it { expect { subject }.to change(Answer, :count).by(1) }

      it_behaves_like 'unauthorized user request' do
        it { expect { subject }.to_not change(Answer, :count) }
      end

      it_behaves_like 'invalid params js', 'empty body', model: Comment do
        let(:form_params) { { body: '' } }
      end

    end
  end

  let(:question) { user.questions.create(title: 'a' * 61, body: 'b' * 120) }

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST create' do

    let(:form_params) { {} }

    let(:params) do
      { answer: attributes_for(:answer).merge(form_params), question_id: question.id, format: :js }
    end

    subject { process :create, method: :post, params: params }

    it_behaves_like '#create', 'answer'

  end

  describe 'PATCH update' do
    let!(:answer) { create(:answer, question: question, user_id: user.id) }
    new_param = ('a' * 61)
    let(:params) do
      {
        answer:     { body: new_param },
        id: answer.id,
        format: :js
      }
    end

    context 'user is not authorized' do
      before do
        patch :update, params: params
        answer.reload
      end

      it 'change attributes' do
        expect(answer.body).to_not eql new_param
      end
    end

    context 'user is authorized' do
      context 'user is not owner' do
        before do
          sign_in john
          patch :update, params: params
          answer.reload
        end

        it 'change attributes' do
          expect(answer.body).to_not eql new_param
        end
      end

      context 'user is owner' do
        before do
          sign_in(user)
          patch :update, params: params
          answer.reload
        end

        it 'change attributes' do
          expect(answer.body).to eql new_param
        end

        it 'render show template' do
          expect(response).to render_template :update
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) do
      {
        id: answer.id,
        format: :js
      }
    end

    context 'user is not authorized' do
      let!(:answer) { create(:answer, question: question, user_id: user.id) }

      it 'does not delete from DB' do
        expect { delete :destroy, params: params }.to_not change(question.answers, :count)
      end

      it 'to not rendered template' do
        delete :destroy, params: params
        expect(response).to_not render_template :destroy
      end
    end

    context 'user is authorized' do
      let!(:answer) { create(:answer, question: question, user_id: user.id) }

      context 'user is not owner' do
        before { sign_in john }

        it 'delete from DB' do
          expect { delete :destroy, params: params }.to_not change { Answer.count }
        end

        it 'redirect to questions/show' do
          delete :destroy, params: params
          expect(response).to be_forbidden
        end
      end

      context 'user is owner' do
        before do
          sign_in(user)
        end

        it 'delete from DB' do
          expect { delete :destroy, params: params }.to change { Answer.count }.by(-1)
        end

        it 'redirect to questions/show' do
          delete :destroy, params: params
          expect(response).to render_template :destroy
        end
      end
    end
  end

  describe 'PATCH #make_best' do
    let(:params) do
      {
        id: answer.id,
        format: :js
      }
    end
    let!(:answer) { question.answers.create(body: 'b' * 120, user: user) }
    let!(:best_answer) { question.answers.create(body: 'z' * 120, user: user, best: true) }

    context 'when user is NOT authorized' do
      before { patch :assign_best, params: params }

      it 'assigns the requested answer on old data' do
        expect(assigns(:answer)).to_not eq answer
      end

      it 'renders template' do
        expect(response).to_not render_template :make_best
      end
    end

    context 'when user is authorized' do
      before { sign_in(user) }

      context 'and he is question`s owner' do
        before { patch :assign_best, params: params }

        it 'assigns the requested answer on old data' do
          expect(assigns(:answer)).to eq answer
        end

        it 'he does change best to true' do
          answer.reload
          best_answer.reload
          expect(answer).to be_best
          expect(best_answer).to_not be_best
        end

        it 'renders template' do
          expect(response).to render_template :assign_best
        end
      end

      context 'and he is not question`s owner' do
        let(:question) { john.questions.create(title: 'a' * 61, body: 'b' * 120) }

        it 'hes does not change best' do
          expect { patch :assign_best, params: params }.to_not change(answer, :best)
        end
      end
    end
  end
end
