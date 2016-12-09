require 'rails_helper'
require_relative 'api_helper'

describe 'Questions API' do
  let(:url) { '/api/v1/questions' }

  describe 'GET /index' do
    it_behaves_like 'unauthorized'

    context 'authorize' do
      include_context 'users'
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        do_request(url, access_token: access_token.token)
      end

      it_behaves_like 'success response'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_date user_id).each do |attr|
        it "question object contains attributes #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question contain short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_date user_id).each do |attr|
          it "contains attributes #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
              .at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question) }
    let!(:attachment) { create(:question_attachment, attachable: question) }
    let(:url) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'unauthorized'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        do_request(url, access_token: access_token.token)
      end

      it_behaves_like 'success response'

      it 'returns the question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_date).each do |attr|
        it "question contains attributes #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      %w(id body created_date user_id).each do |attr|
        it "contains comment #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
        end
      end

      it 'contains attachment`s filename' do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path('question/attachments/0/name')
      end

      it 'contains attachment`s` url' do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/src')
      end
    end
  end

  describe 'POST #create' do
    let(:http_method) { :post }

    it_behaves_like 'unauthorized'

    context 'authorized and question has valid data' do
      let(:access_token) { create(:access_token) }

      let(:params) do
        {
          question:    attributes_for(:question),
          access_token: access_token.token,
          format:      :json
        }
      end

      before do
        do_request(url, http_method, params)
      end

      it_behaves_like 'success response'
    end

    context 'authorized and post invalid data' do
      let(:access_token) { create(:access_token) }
      let(:params) do
        {
          question:     { title: nil, body: nil },
          access_token: access_token.token,
          format:      :json
        }
      end

      before do
        do_request(url, http_method, params)
      end

      it 'returns 422 status code' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        expect(response.body).to have_json_path('errors')
      end
    end
  end
end
