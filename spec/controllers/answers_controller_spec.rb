require 'rails_helper'
require_relative 'concerns/voted'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:question) { @user.questions.create(title: 'a' * 61, body: 'b' * 120) }

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @other_user = create :user
    @user = create :user
  end

  describe 'POST create' do
    let(:params) do
      {
        answer:      attributes_for(:answer),
        question_id: question.id,
        format: :js
      }
    end

    context 'not authorized user' do
      it 'dont save the new answer in a DB' do
        expect { post :create, params: params }.to_not change(question.answers, :count)
      end
    end

    context 'authorized user' do
      before { sign_in @user }

      context 'with valid attributes' do
        it 'save the new answer in a DB' do
          expect { post :create, params: params }.to change(question.answers, :count).by(1)
        end

        it 'save the new answer in a DB with user relation' do
          expect { post :create, params: params }.to change(@user.answers, :count).by(1)
        end

        it 'redirect_to question' do
          post :create, params: params
          expect(response).to render_template :create
        end
      end

      context 'with invalid attr' do
        let(:wrong_params) do
          {
            answer:      attributes_for(:wrong_answer),
            question_id: question.id,
            format: :js
          }
        end
        it 'dont save in a DB' do
          expect { post :create, params: wrong_params }.to_not change(Answer, :count)
        end

        it 'redirect to questions/show' do
          post :create, params: wrong_params
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'PATCH update' do
    let!(:answer) { create(:answer, question: question, user_id: @user.id) }
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
          sign_in @other_user
          patch :update, params: params
          answer.reload
        end

        it 'change attributes' do
          expect(answer.body).to_not eql new_param
        end
      end

      context 'user is owner' do
        before do
          sign_in @user
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
      let!(:answer) { create(:answer, question: question, user_id: @user.id) }

      it 'does not delete from DB' do
        expect { delete :destroy, params: params }.to_not change(question.answers, :count)
      end

      it 'to not rendered template' do
        delete :destroy, params: params
        expect(response).to_not render_template :destroy
      end
    end

    context 'user is authorized' do
      let!(:answer) { create(:answer, question: question, user_id: @user.id) }

      context 'user is not owner' do
        before { sign_in @other_user }

        it 'delete from DB' do
          expect { delete :destroy, params: params }.to_not change { Answer.count }
        end

        it 'redirect to questions/show' do
          delete :destroy, params: params
          expect(response).to redirect_to root_path
        end
      end

      context 'user is owner' do
        before do
          sign_in @user
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
    let!(:answer) { question.answers.create(body: 'b' * 120, user: @user) }
    let!(:best_answer) { question.answers.create(body: 'z' * 120, user: @user, best: true) }

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
      before { sign_in @user }

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
        let(:question) { @other_user.questions.create(title: 'a' * 61, body: 'b' * 120) }

        it 'hes does not change best' do
          expect { patch :assign_best, params: params }.to_not change(answer, :best)
        end
      end
    end
  end
end
