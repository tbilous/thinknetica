require 'rails_helper'

describe 'Questions API' do

  shared_examples 'unauthorized' do
    context 'unauthorized' do
      let(:invalid_params) do
        {
          format: :json,
          access_token: '1234'
        }
      end

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: {format: invalid_params[:format] }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: invalid_params
        expect(response.status).to eq 401
      end
    end
  end
  describe 'GET /index' do
    context 'unauthorize' do
      it_behaves_like 'unauthorized'
    end

    context 'authorize' do
      include_context 'users'
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question)}

      before {
        get '/api/v1/questions',
            params: { access_token: access_token.token, format: :json }
      }

      it 'returns 200 status if access_token is valid' do
        expect(response).to be_success
      end

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
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end
