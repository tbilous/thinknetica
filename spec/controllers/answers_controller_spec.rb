require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  context 'non authorized user' do
    describe 'POST create' do
      let(:attr) { attributes_for(:answer) }

      it 'save the new answer in a DB' do
        expect { post :create, question_id: question.id, answer: attr }.to_not change(question.answers, :count)
      end

      it 'redirect_to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer, question: question) }

      it 'delete from DB' do
        expect { delete :destroy, id: answer.id }.to_not change(question.answers, :count)
      end

      it 'redirect to questions/show' do
        delete :destroy, id: answer.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  context ' authorized user' do
    login_user
    describe 'POST create' do
      context 'with valid attributes' do
        let(:attr) { attributes_for(:answer) }

        it 'save the new answer in a DB' do
          expect { post :create, question_id: question.id, answer: attr }.to change(question.answers, :count).by(1)
        end

        it 'redirect_to question' do
          post :create, question_id: question, answer: attributes_for(:answer)
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attr' do
        it 'does not save in a DB' do
          expect { post :create, question_id: question, answer: { body: nil } }.to_not change(Answer, :count)
        end

        it 'redirect to questions/show' do
          post :create, question_id: question, answer: { body: nil }
          expect(response).to render_template 'questions/show'
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer, question: question) }
      before(:each) do
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
