require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @other_user = create :user
    @user = create :user
  end

  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'DELETE destroy' do
    let!(:comment) { create(:comment, user:@user, commentable: question) }

    context 'User does not authorized' do
      it 'do not delete in DB' do
        expect { delete :destroy, params: { id: comment.id, format: :js } }.to_not change { Comment.count }
      end
    end

    context 'User is authorized' do
      context 'user is owner' do
        before { sign_in(@user) }

        it 'delete in DB' do
          expect { delete :destroy, params: { id: comment.id, format: :js } }.to change { Comment.count }
        end
      end

      context 'user not is owner' do
        before { sign_in(@other_user) }

        it 'do not delete in DB' do
          expect { delete :destroy, params: { id: comment.id, format: :js } }.to_not change { Comment.count }
        end
      end

    end
  end

end
