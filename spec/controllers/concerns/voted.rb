require 'rails_helper'

shared_examples 'voted' do
  let!(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: user) }
  let(:params) do
    {
      id: model.id,
      format: :json
    }
  end


  shared_examples 'votesable' do

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change { model.votes.where(votesable: model).sum(:challenge) } }
    end

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to_not change { model.votes.where(votesable: model).sum(:challenge) } }

      it 'assings the requested post to @votable' do
        patch :vote_plus, params: params
        expect(assigns(:votesable)).to eq model
      end
    end
  end


  describe 'PATCH #vote_plus' do
    subject { patch :vote_plus, params: params }

    it_behaves_like 'votesable'

    it_behaves_like 'when user not is owner' do

      it { expect { subject }.to change { model.votes.where(votesable: model).sum(:challenge) } }

      it 'assings the requested post to @votable' do
        subject
        expect(assigns(:votesable)).to eq model
      end

      context 'when voted previously' do
        before { subject }

        it 'increase post`s rating' do
          expect { subject }.to_not change { model.votes.where(votesable: model, user: john).sum(:challenge) }
        end
      end
    end
  end

  describe 'PATCH #vote_minus' do

    subject { patch :vote_minus, params: params }

    it_behaves_like 'votesable'

    it_behaves_like 'when user not is owner' do

      it { expect { subject }.to change { model.votes.where(votesable: model).sum(:challenge) } }

      it 'assings the requested post to @votable' do
        subject
        expect(assigns(:votesable)).to eq model
      end

      context 'when voted previously' do
        before { subject }

        it 'increase post`s rating' do
          expect { subject }.to_not change { model.votes.where(votesable: model, user: john).sum(:challenge) }
        end
      end
    end
  end

  describe 'PATCH #vote_cancel' do
    let(:params) do
      {
        id: model.id,
        user: user,
        format: :json
      }
    end

    subject { patch :vote_cancel, params: params }

    it_behaves_like 'votesable' do
      before { patch :vote_minus, params: params }
    end


    it_behaves_like 'when user not is owner' do
      it { expect { subject }.to_not change { model.votes.where(votesable: model).sum(:challenge) } }

      it 'assings the requested post to @votable' do
        subject
        expect(assigns(:votesable)).to eq model
      end

      context 'when voted previously' do
        before { patch :vote_minus, params: params }

        it 'increase post`s rating' do
          expect { subject }.to change { model.votes.where(votesable: model, user: john).sum(:challenge) }
        end
      end
    end
  end
end
