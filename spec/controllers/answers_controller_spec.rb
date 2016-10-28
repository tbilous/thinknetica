require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { @user.questions.create(title: 'a'*61, body: 'b'*120 ) }

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @other_user = create :user
    @user = create :user
  end

  describe 'POST create' do
    context 'not authorized user' do
      let(:attr) { attributes_for(:answer) }

      it 'dont save the new answer in a DB' do
        expect { post :create, question_id: question.id, answer: attr, format: :js }.to_not change(question.answers,
                                                                                                   :count)
      end

      it 'redirect_to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized user' do
      before { sign_in @user }

      context 'with valid attributes' do
        let(:attr) { attributes_for(:answer) }

        it 'save the new answer in a DB' do
          expect { post :create, question_id: question.id, answer: attr, format: :js }.to change(
            question.answers,
            :count
          ).by(1)
        end

        it 'save the new answer in a DB with user relation' do
          expect { post :create, question_id: question.id, answer: attr, format: :js }.to change(
            @user.answers,
            :count
          ).by(1)
        end

        it 'redirect_to question' do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attr' do
        it 'dont save in a DB' do
          expect { post :create, question_id: question, answer: { body: nil }, format: :js }.to_not change(
            Answer, :count
          )
        end

        it 'redirect to questions/show' do
          post :create, question_id: question, answer: { body: nil }, format: :js
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'PATCH update' do
    let!(:answer) { create(:answer, question: question, user_id: @user.id) }
    new_param = ('b' * 61)
    let(:attr) { { body: 'b' * 61 } }

    context 'user is not authorized' do
      before do
        patch :update, id: answer.id, body: attr
        answer.reload
      end

      it 'change attributes' do
        expect(answer.body).to_not eql attr
      end

      it 'render show template' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user is authorized' do
      context 'user is not owner' do
        before do
          sign_in @other_user
          patch :update, id: answer.id, body: attr
          answer.reload
        end

        it 'change attributes' do
          expect(answer.body).to_not eql attr
        end

        it 'render show template' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user is owner' do
        before do
          sign_in @user
          patch :update, id: answer.id, answer: attr, format: :js
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
    context 'user is not authorized' do
      let!(:answer) { create(:answer, question: question, user_id: @user.id) }

      it 'does not delete from DB' do
        expect { delete :destroy, id: answer.id }.to_not change(question.answers, :count)
      end

      it 'redirect to questions/show' do
        delete :destroy, id: answer.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user is authorized' do
      let!(:answer) { create(:answer, question: question, user_id: @user.id) }

      context 'user is not owner' do
        before { sign_in @other_user }

        it 'delete from DB' do
          expect { delete :destroy, id: answer.id }.to_not change { Answer.count }
        end

        it 'redirect to questions/show' do
          delete :destroy, id: answer.id
          expect(response).to redirect_to root_path
        end
      end

      context 'user is owner' do
        before do
          sign_in @user
          request.env['HTTP_REFERER'] = 'where_i_came_from'
        end
        it 'delete from DB' do
          expect { delete :destroy, id: answer.id }.to change { Answer.count }.by(-1)
        end

        it 'redirect to questions/show' do
          delete :destroy, id: answer.id
          expect(response).to redirect_to 'where_i_came_from'
        end
      end
    end
  end

  describe 'PATCH #make_best' do
    let!(:answer)  { question.answers.create(body: 'b'*120, user: @user) }
    let!(:best_answer)  { question.answers.create(body: 'z'*120 , user: @user, best: true) }

    context 'when user is NOT authorized' do
      before { patch :assign_best, id: answer.id, format: :js }

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
        before { patch :assign_best, id: answer.id, format: :js }

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
        let(:question) { @other_user.questions.create(title: 'a'*61, body: 'b'*120 ) }

        it 'hes does not change best' do
          expect { patch :assign_best, id: answer.id, format: :js }.to_not change(answer, :best)
        end
      end
    end
  end
end
