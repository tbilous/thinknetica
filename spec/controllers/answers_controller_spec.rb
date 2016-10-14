require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'POST create' do
    context 'with valid attributes' do
      let(:attr)  { attributes_for(:answer) }
      it 'save the new answer in a DB' do
        expect { post :create, question_id: question.id, answer: attr }.to change(Answer, :count).by(1)
      end
      it 'redirect_to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to render_template 'questions/show'
      end
    end
    context 'with invalid attr' do
      let(:attr) do
        { body: 'b' }
      end
      it 'does not save in a DB' do
        expect { post :create, question_id: question, answer: attr }.to_not change(Answer, :count)
      end

      it 'redirect to questions/show' do
        post :create, question_id: question, answer: { body: nil }
        expect(response).to render_template 'questions/show'
      end
    end
  end
  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question_id: question.id) }
    it 'delete from DB' do
      expect { delete :destroy, id: answer.id }.to change { Answer.count }.by(-1)
    end
    it 'redirect to questions/show' do
      delete :destroy, id: answer.id
      expect(response).to render_template 'questions/show'
    end
  end
end
