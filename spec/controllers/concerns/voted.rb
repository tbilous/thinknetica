require 'rails_helper'

shared_examples 'voted' do
  let!(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: @user) }

  describe 'PATCH #vote_plus' do
    let(:params) do
      {
        id: model.id,
        format: :json
      }
    end

    context 'User is not authenticated' do
      it 'increase post`s rating' do
        expect { patch :vote_plus, params: params }
          .to_not change { model.votes.where(votesable: model).sum(:challenge) }
      end
    end
    context 'User is authenticated' do
      context 'and owner' do
        before { sign_in @user }
        it 'assings the requested post to @votable' do
          patch :vote_plus, params: params
          expect(assigns(:votesable)).to eq model
        end

        it 'increase post`s rating' do
          expect { patch :vote_plus, params: params }
            .to_not change { model.votes.where(votesable: model, user: @user).sum(:challenge) }
        end
      end

      context 'and not owner' do
        before { sign_in @other_user }

        it 'assings the requested post to @votable' do
          patch :vote_plus, params: params
          expect(assigns(:votesable)).to eq model
        end

        it 'increase post`s rating' do
          expect { patch :vote_plus, params: params }
            .to change { model.votes.where(votesable: model, user: @other_user).sum(:challenge) }.by(1)
        end

        context 'when voted previously' do
          before { patch :vote_plus, params: params }

          it 'increase post`s rating' do
            expect { patch :vote_plus, params: params }
              .to_not change { model.votes.where(votesable: model, user: @other_user).sum(:challenge) }
          end
        end
      end
    end
  end

  describe 'PATCH #vote_minus' do
    let(:params) do
      {
        id: model.id,
        format: :json
      }
    end

    context 'User is not authenticated' do
      it 'increase post`s rating' do
        expect { patch :vote_plus, params: params }
          .to_not change { model.votes.where(votesable: model).sum(:challenge) }
      end
    end
    context 'User is authenticated'
    context 'and owner' do
      before { sign_in @user }
      it 'assings the requested post to @votable' do
        patch :vote_plus, params: params
        expect(assigns(:votesable)).to eq model
      end

      it 'increase post`s rating' do
        expect { patch :vote_plus, params: params }
          .to_not change { model.votes.where(votesable: model, user: @user).sum(:challenge) }
      end
    end

    context 'and not owner' do
      before { sign_in @other_user }

      it 'assings the requested post to @votable' do
        patch :vote_minus, params: params
        expect(assigns(:votesable)).to eq model
      end

      it 'increase post`s rating' do
        expect { patch :vote_minus, params: params }
          .to change { model.votes.where(votesable: model, user: @other_user).sum(:challenge) }.by(-1)
      end

      context 'when voted previously' do
        before { patch :vote_minus, params: params }

        it 'increase post`s rating' do
          expect { patch :vote_minus, params: params }
            .to_not change { model.votes.where(votesable: model, user: @other_user).sum(:challenge) }
        end
      end
    end
  end

  describe 'PATCH #vote_cancel' do
    let(:params) do
      {
        id: model.id,
        user: @user,
        format: :json
      }
    end
    context 'User is not authenticated' do
      before { patch :vote_minus, params: params }

      it 'increase post`s rating' do
        expect { patch :vote_cancel, params: params }
          .to_not change { model.votes.where(votesable: model).sum(:challenge) }
      end
    end
    context 'User is authenticated'
    context 'and owner' do
      before { patch :vote_minus, params: params }

      it 'increase post`s rating' do
        expect { patch :vote_plus, params: params }
          .to_not change { model.votes.where(votesable: model, user: @user).sum(:challenge) }
      end
    end

    context 'and not owner' do
      let(:params) do
        {
          id: model.id,
          format: :json
        }
      end

      before { sign_in @other_user }

      it 'assings the requested post to @votable' do
        patch :vote_minus, params: params
        expect(assigns(:votesable)).to eq model
      end

      it 'increase post`s rating' do
        expect { patch :vote_minus, params: params }
          .to change { model.votes.where(votesable: model, user: @other_user).sum(:challenge) }.by(-1)
      end

      context 'when voted previously' do
        before { patch :vote_minus, params: params }

        it 'increase post`s rating' do
          expect { patch :vote_minus, params: params }
            .to_not change { model.votes.where(votesable: model, user: @other_user).sum(:challenge) }
        end
      end
    end
  end
end
