require 'rails_helper'
require_relative 'concerns/voted'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'
  include_context 'users'

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'list all' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders the index template' do
      expect(response).to render_template :index
    end

    it_behaves_like 'when user is authorized' do
      it { expect(assigns(:question)).to be_a_new(Question) }
      it { expect(assigns(:question).attachments.first).to be_a_new(Attachment) }
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question.id } }

    it 'render the show template' do
      expect(response).to render_template :show
    end
    it 'assign answer ' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'assign answer attachment' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'GET #new' do
  end

  describe 'GET #edit' do
  end

  describe 'POST #create' do
    let(:form_params) { {} }
    let(:params) do
      {
        question: attributes_for(:question).merge(form_params)
      }
    end

    subject { post :create, params: params }

    it_behaves_like 'when user is unauthorized' do
      it { expect { subject }.to_not change(Question, :count) }
      it { expect(subject).to redirect_to new_user_session_path }
    end

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change(Question, :count) }

      it_behaves_like 'invalid params concern', 'empty body', model: Question do
        let(:form_params) { { body: '' } }
      end
      it_behaves_like 'invalid params concern', 'empty title', model: Question do
        let(:form_params) { { title: '' } }
      end
    end
  end

  describe 'PATCH update' do
    let(:form_params) do
      {
        title: 'b' * 6,
        body: 'z' * 6
      }
    end

    let(:params) do
      {
        id: question.id,
        format: :js,
        question: attributes_for(:question).merge(form_params)
      }
    end

    subject do
      patch :update, params: params
      question.reload
    end

    it_behaves_like 'when user is unauthorized' do
      before { subject }
      it { expect(question.body).to_not eql params[:question][:body] }
      it { expect(question.title).to_not eql params[:question][:title] }
    end

    it_behaves_like 'when user not is owner' do
      before { subject }
      it { expect(question.body).to_not eql params[:question][:body] }
      it { expect(question.title).to_not eql params[:question][:title] }
    end

    it_behaves_like 'when user is authorized' do
      before { subject }
      it { expect(question.body).to eql params[:question][:body] }
      it { expect(question.title).to eql params[:question][:title] }
      it { expect(question).to render_template :update }

      it_behaves_like 'invalid params js', 'empty title', model: Question do
        let(:form_params) { { body: '' } }
        before { subject }
      end
      it_behaves_like 'invalid params js', 'empty title', model: Question do
        let(:form_params) { { title: '' } }
        before { subject }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    subject do
      delete :destroy, params: { id: question.id }
    end
    it_behaves_like 'when user is unauthorized' do
      it {  expect { subject }.to_not change { Question.count } }
      it { expect(subject).to redirect_to new_user_session_path }
    end

    it_behaves_like 'when user not is owner' do
      it {  expect { subject }.to_not change { Question.count } }
      it { expect(subject).to redirect_to root_path }
    end

    it_behaves_like 'when user is authorized' do
      it { expect { subject }.to change { Question.count }.by(-1) }
      it { expect(subject).to redirect_to questions_path }
    end
  end
end
