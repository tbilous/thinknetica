require 'rails_helper'

describe 'Profile API' do
  shared_examples 'unauthorized' do |context_name|
    context 'unauthorized' do
      let(:invalid_params) do
        {
          format: :json,
          access_token: '1234'
        }
      end

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/profiles/#{context_name}", params: { format: invalid_params[:format] }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/profiles/#{context_name}", params: invalid_params
        expect(response.status).to eq 401
      end
    end
  end

  shared_examples 'check response' do |context_name|
    include_context 'users'

    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    before do
      get "/api/v1/profiles/#{context_name}",
          params: { access_token: access_token.token, format: :json }
    end

    it 'returns success response' do
      expect(response).to be_success
    end
    allowed_attributes = %w(id email name created_at updated_at)
    disallowed_attributes = %w(password encrypted_password)
    if context_name == 'me'

      allowed_attributes.each do |attr|
        it "returns user #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      disallowed_attributes.each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    else
      it 'returns list without user' do
        expect(response.body).to have_json_size(2)
        expect(response.body).to be_json_eql(users.to_json)
        expect(response.body).to_not include_json(user.to_json)
      end

      allowed_attributes.each do |attr|
        it "each list of users contains #{attr}" do
          users.each_with_index do |user, i|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{i}/#{attr}")
          end
        end
      end

      disallowed_attributes.each do |attr|
        it "each list of users does not contain #{attr}" do
          users.each_index do |i|
            expect(response.body).to_not have_json_path("#{i}/#{attr}")
          end
        end
      end

    end
  end

  describe 'GET /me' do
    it_behaves_like 'unauthorized', 'me'

    context 'authorized' do
      it_behaves_like 'check response', 'me'
    end
  end

  describe 'GET /index' do
    it_behaves_like 'unauthorized'

    context 'authorized' do
      let!(:users) { create_list(:user, 2) }

      it_behaves_like 'check response'
    end
  end
end
