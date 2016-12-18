require 'rails_helper'
require_relative 'api_helper'

describe 'Answers API' do
  include_context 'users'
  let!(:question) { create(:question, user: user) }
  let!(:url) { "/api/v1/questions/#{question.id}/answers" }

  describe 'GET #index' do
    it_behaves_like 'unauthorized'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:first_answer) { answers.first }
      let(:access_token) { create(:access_token) }

      before do
        do_request(url, access_token: access_token.token)
      end

      it_behaves_like 'success response'

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(body created_date).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(first_answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: answer) }
    let!(:attachment) { create(:answer_attachment, attachable: answer) }
    let!(:url) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'unauthorized'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        do_request(url, access_token: access_token.token)
      end

      it_behaves_like 'success response'

      it 'returns the answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_date).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      %w(id body created_date user_id).each do |attr|
        it "answer's comment object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
        end
      end

      it 'contains attachment`s filename' do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path('answer/attachments/0/name')
      end

      it 'contains attachment`s` url' do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/src')
      end
    end
  end

  describe 'POST #create' do
    let(:http_method) { :post }
    it_behaves_like 'unauthorized'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      context 'valid data' do
        let(:params) do
          {
            answer:       attributes_for(:answer),
            question_id:  question.id,
            access_token: access_token.token,
            format:       :json
          }
        end

        before do
          do_request(url, http_method, params)
        end

        it_behaves_like 'success response'
      end

      context 'invalid data' do
        let(:params) do
          {
            answer:       { body: nil },
            question_id:  question.id,
            access_token: access_token.token,
            format:       :json
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
end
