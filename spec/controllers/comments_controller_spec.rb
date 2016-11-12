require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  shared_examples "comments #create" do |context_name|
    context context_name do

      context 'User is authorized' do
        context 'change comments count' do
          before { sign_in(@user) }
          it {expect { subject }.to change(context.comments, :count).by(1)}
        end
      end

      context 'User is not authorized' do
        it "do not change comments count" do
          expect { subject }.to_not change(context.comments, :count)
        end
      end

      # it_behaves_like "invalid params", "empty body", model: Comment do
      #   let(:form_params) { { body: '' } }
      # end
    end
  end


  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @other_user = create :user
    @user = create :user
  end


  describe 'POST #create' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    let(:form_params) { {} }

    let(:params) do
      { comment: attributes_for(:comment).merge(form_params), format: :js }.merge(context_params)
    end

    subject { process :create, method: :post, params: params }

    it_behaves_like "comments #create", "question" do
      let(:context_params) { { question_id: question, context: 'question' } }
      let(:context) { question }
    end

    it_behaves_like "comments #create", "answer" do
      let(:context_params) { { answer_id: answer, context: 'answer' } }
      let(:context) { answer }
    end
  end

  describe 'DELETE destroy' do
    let(:question) { create(:question, user: @user) }
    let(:answer) { create(:answer, question: question, user: @user) }
    let!(:comment) { create(:comment, user:@user, commentable: question) }

    context 'User is not authorized' do
      it 'do not delete in DB' do
        expect { delete :destroy, params: { id: comment.id, format: :js } }.to_not change { Comment.count }
      end
    end

    context 'User is authorized' do
      context 'when he is owner' do
        before { sign_in(@user) }

        it 'does delete in DB' do
          expect { delete :destroy, params: { id: comment.id, format: :js } }.to change { Comment.count }
        end
      end

      context 'when he is not owner' do
        before { sign_in(@other_user) }

        it 'does not delete in DB' do
          expect { delete :destroy, params: { id: comment.id, format: :js } }.to_not change { Comment.count }
        end
      end

    end
  end

end
