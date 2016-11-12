require 'rails_helper'
require_relative 'concerns/voted'
require_relative 'concerns/commented'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @other_user = create :user
    @user = create :user
  end

  let(:question) { create(:question, user: @user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'list all' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders the index template' do
      expect(response).to render_template :index
    end

    context 'user is authorized' do
      login_user

      it 'assign New Question' do
        expect(assigns(:question)).to be_a_new(Question)
      end
      it 'assign Attach' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question.id } }

    it 'assign question' do
      expect(assigns(:question)).to eq question
    end

    it 'render the show template' do
      expect(response).to render_template :show
    end
    context 'user is not authorized', js: true do
      before { get :edit, params: { id: question.id } }

      it 'assign Edit Question' do
        expect(assigns(:question)).to eq question
      end
    end

    context 'user is authorized', js: true do
      context 'attach' do
        login_user
        it 'assign Attach' do
          expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
        end
      end
      context 'user not is not owner' do
        before do
          sign_in @other_user
          get :edit, params: { id: question.id, format: :js }
        end
        it 'assign Edit Question' do
          expect(assigns(:question)).to eq question
        end
      end

      context 'user is owner' do
        before do
          sign_in @user
          get :edit, params: { id: question.id, format: :js }
        end
        it 'assign Edit Question' do
          expect(assigns(:question)).to eq question
        end
      end
    end
  end

  describe 'GET #new' do
  end

  describe 'GET #edit' do
  end

  describe 'POST #create' do
    let(:params) do
      {
        question: attributes_for(:question)
      }
    end

    context 'user is not authorized' do
      it 'add tot database' do
        expect { post :create, params: params }.to_not change(Question, :count)
      end
      it 'redirect to show' do
        post :create, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'user is authorized' do
      before { sign_in @other_user }

      describe 'POST #create' do
        context 'attr is valid' do
          it 'add tot database' do
            expect { post :create, params: params }.to change(@other_user.questions, :count).by(1)
          end
          it 'redirect to show' do
            post :create, params: params
            expect(response).to redirect_to question_path(assigns(:question))
          end
        end

        context 'attr is not valid' do
          let(:wrong_params) do
            {
              question: attributes_for(:wrong_question)
            }
          end

          it 'does not add to database' do
            expect { post :create, params: wrong_params }.to_not change(Question, :count)
          end

          it 'render new' do
            post :create, params: wrong_params
            { title: 'b' * 6, body: 'b' * 61 }
          end
        end
      end
    end
  end

  describe 'PATCH update' do
    let(:new_attr) do
      {
        title: 'b' * 5,
        body: 'b' * 61
      }
    end

    let(:params) do
      {
        id: question.id,
        question:     { title: new_attr[:title], body: new_attr[:body] },
        format: :js
      }
    end
    let(:wrong_params) do
      {
        id: question.id,
        question:     { title: nil, body: nil },
        format: :js
      }
    end
    context 'user is not authorized' do
      let(:attr) do
        { title: 'b' * 6, body: 'b' * 61 }
      end

      before do
        patch :update, params: params
        question.reload
      end

      it 'change attributes' do
        expect(question.title).to_not eql new_attr[:title]
        expect(question.body).to_not eql new_attr[:body]
      end
    end

    context 'user is authorized' do
      context 'user user is not owner' do
        before { sign_in @other_user }

        let(:attr) do
          { title: 'b' * 6, body: 'b' * 61 }
        end
        before do
          patch :update, params: params
          question.reload
        end

        it 'change attributes' do
          expect(question.title).to_not eql new_attr[:title]
          expect(question.body).to_not eql new_attr[:body]
        end

        it 'render show template' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user is owner' do
        before { sign_in @user }

        context 'attr is valid' do
          let(:attr) do
            { title: 'b' * 6, body: 'b' * 61 }
          end
          before do
            patch :update, params: params
            question.reload
          end

          it 'change attributes' do
            expect(question.title).to eql new_attr[:title]
            expect(question.body).to eql new_attr[:body]
          end

          it 'render show template' do
            expect(response).to render_template :update
          end
        end

        context 'attr is not valid' do
          let(:attr) do
            { title: 'b', body: 'b' }
          end
          before do
            patch :update, params: wrong_params
            question.reload
          end

          it 'does not change attributes' do
            expect(question.title).to_not eql wrong_params[:title]
            expect(question.body).to_not eql wrong_params[:body]
          end

          it 'render edit template' do
            expect(response).to render_template :update
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user is not authorized' do
      let!(:question) { create(:question) }

      it 'delete in DB' do
        expect { delete :destroy, params: { id: question.id } }.to_not change { Question.count }
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'user is authorized' do
      context 'user is not owner' do
        before { sign_in @other_user }

        let!(:question) { create(:question, user: @user) }

        it 'delete in DB' do
          expect { delete :destroy, params: { id: question.id } }.to_not change { Question.count }
        end

        it 'redirect to index' do
          delete :destroy, params: { id: question.id }
          expect(response).to redirect_to root_path
        end
      end

      context 'user is owner' do
        before { sign_in @user }

        let!(:question) { create(:question, user: @user) }

        it 'delete in DB' do
          expect { delete :destroy, params: { id: question.id } }.to change { Question.count }.by(-1)
        end

        it 'redirect to index' do
          delete :destroy, params: { id: question.id }
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
