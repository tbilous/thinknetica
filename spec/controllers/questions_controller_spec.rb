require 'rails_helper'
require_relative 'concerns/do_vote'

RSpec.describe QuestionsController, type: :controller do

  it_behaves_like 'do_vote'

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
  end

  describe 'GET #show' do
    before { get :show, id: question.id }

    it 'assign question' do
      expect(assigns(:question)).to eq question
    end

    it 'assign Attach' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'render the show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'user is not authorized' do
      let(:question) { create(:question) }
      before { get :new }

      it 'assign New Question' do
        expect(assigns(:question)).to_not be_a_new(Question)
      end

      it 'render the new template' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user is authorized' do
      login_user

      before { get :new }

      it 'assign New Question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assign Attach' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end

      it 'render the new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    context 'user is not authorized' do
      before { get :edit, id: question.id }
      it 'assign Edit Question' do
        expect(assigns(:question)).to_not eq question
      end

      it 'render the edit template' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user is authorized' do
      context 'user not is not owner' do
        before do
          sign_in @other_user
          get :edit, id: question.id
        end
        it 'assign Edit Question' do
          expect(assigns(:question)).to eq question
        end
        it 'render the edit template' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user is owner' do
        before do
          sign_in @user
          get :edit, id: question.id
        end
        it 'assign Edit Question' do
          expect(assigns(:question)).to eq question
        end
        it 'render the edit template' do
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'POST #create' do
    context 'user is not authorized' do
      question_params = FactoryGirl.attributes_for(:question)
      it 'add tot database' do
        expect { post :create, question: question_params }.to_not change(Question, :count)
      end
      it 'redirect to show' do
        post :create, question: question_params
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'user is authorized' do
      before { sign_in @other_user }

      describe 'POST #create' do
        context 'attr is valid' do
          question_params = FactoryGirl.attributes_for(:question)
          it 'add tot database' do
            expect { post :create, question: question_params }.to change(@other_user.questions, :count).by(1)
          end
          it 'redirect to show' do
            post :create, question: question_params
            expect(response).to redirect_to question_path(assigns(:question))
          end
        end

        context 'attr is not valid' do
          invalid_params = FactoryGirl.attributes_for(:wrong_question)

          it 'does not add to database' do
            expect { post :create, question: invalid_params }.to_not change(Question, :count)
          end

          it 'render new' do
            post :create, question: invalid_params
            { title: 'b' * 6, body: 'b' * 61 }
          end
        end
      end
    end
  end

  describe 'PATCH update' do
    context 'user is not authorized' do
      let(:attr) do
        { title: 'b' * 6, body: 'b' * 61 }
      end

      before do
        patch :update, id: question.id, question: attr
        question.reload
      end

      it 'change attributes' do
        expect(question.title).to_not eql attr[:title]
        expect(question.body).to_not eql attr[:body]
      end

      it 'render show template' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user is authorized' do
      context 'user user is not owner' do
        before { sign_in @other_user }

        let(:attr) do
          { title: 'b' * 6, body: 'b' * 61 }
        end
        before do
          patch :update, id: question.id, question: attr
          question.reload
        end

        it 'change attributes' do
          expect(question.title).to_not eql attr[:title]
          expect(question.body).to_not eql attr[:body]
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
            patch :update, id: question.id, question: attr, format: :js
            question.reload
          end

          it 'change attributes' do
            expect(question.title).to eql attr[:title]
            expect(question.body).to eql attr[:body]
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
            patch :update, id: question.id, question: attr, format: :js
            question.reload
          end

          it 'does not change attributes' do
            expect(question.title).to_not eql attr[:title]
            expect(question.body).to_not eql attr[:body]
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
        expect { delete :destroy, id: question.id }.to_not change { Question.count }
      end

      it 'redirect to index' do
        delete :destroy, id: question.id
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'user is authorized' do
      context 'user is not owner' do
        before { sign_in @other_user }

        let!(:question) { create(:question, user: @user) }

        it 'delete in DB' do
          expect { delete :destroy, id: question.id }.to_not change { Question.count }
        end

        it 'redirect to index' do
          delete :destroy, id: question.id
          expect(response).to redirect_to root_path
        end
      end

      context 'user is owner' do
        before { sign_in @user }

        let!(:question) { create(:question, user: @user) }

        it 'delete in DB' do
          expect { delete :destroy, id: question.id }.to change { Question.count }.by(-1)
        end

        it 'redirect to index' do
          delete :destroy, id: question.id
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
