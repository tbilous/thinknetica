require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @other_user = create :user
    @user = create :user
  end
  # let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

  describe 'PATCH #vote_plus' do
    let!(:question) { create(:question, user: @user) }

    context 'user is not authorized' do
      before { patch :assign_best, id: answer.id, format: :js }

      it 'assigns the requested answer on old data' do
        expect(assigns(:question)).to_not eq questin
      end

    end

    context 'user is authorized' do
      context 'user is not owner' do
        sign_in(@other_user)

        context 'when user is NOT authorized' do
          before { patch :vote_plus, id: question.id, format: :js }

          it 'assigns the requested answer on old data' do
            expect(assigns(:question)).to_not eq question
          end

          it 'renders template' do
            expect(response).to_not render_template :make_best
          end
        end

      end

      context 'user is  owner' do
        sign_in(@user)

      end
    end
  end
end
