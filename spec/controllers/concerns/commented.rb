require 'rails_helper'

shared_examples 'commented' do
  let!(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: @user) }
  context = described_class.controller_name.classify.underscore.to_sym

  describe 'PATCH #comment_create' do
    let(:params) do
      {
        context: context,
        id: model.id,
        body: 'a' * 6,
        format: :json
      }
    end
    context 'User is not authenticated' do
      it 'comment does not created in DB' do
        expect { post :question_comments, params: params }
          .to_not change(model.comments.where(commentable: model), :count)
      end
    end
    context 'User is authorized' do
      before do
        sign_in(@user)
      end

      it 'comment has created in DB' do
        expect { post :comment_create, params: params }
          .to change(model.comments.where(commentable: model), :count).by(1)
      end
    end
  end
end
