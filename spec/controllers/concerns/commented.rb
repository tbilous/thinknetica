require 'rails_helper'

shared_examples 'commented' do
  let!(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: @user) }

  describe 'PATCH #comment_create' do

    let(:params) do
      {
          id: model.id,
          body: 'a' * 6,
          format: :json
      }
    end
    context 'User is not authenticated' do
      it 'comment does not created in DB' do
        expect { patch :comment_create, params: params }
            .to_not change(model.comments.where(commentable: model), :count)
      end
    end
    context 'User is authorized' do
      before {
        sign_in(@user)
      }

      it 'comment has created in DB' do
        expect { patch :comment_create, params: params }
            .to change(model.comments.where(commentable: model), :count).by(1)
      end
    end
  end
end
