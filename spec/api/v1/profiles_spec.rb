require 'rails_helper'
require_relative 'api_helper'

describe 'Profile API' do
  allowed_attributes = %w(id email name created_at updated_at)
  disallowed_attributes = %w(password encrypted_password)

  describe 'GET /me' do
    let(:url) { '/api/v1/profiles/me' }
    it_behaves_like 'unauthorized', 'me'

    context 'authorized' do
      include_context 'users'

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        do_request(url, { access_token: access_token.token })
      end

      it_behaves_like 'success response'

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
    end
  end

  describe 'GET /index' do
    let(:url) { '/api/v1/profiles' }

    it_behaves_like 'unauthorized'

    context 'authorized' do
      let!(:users) { create_list(:user, 2) }

      include_context 'users'

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        do_request(url, { access_token: access_token.token })
      end

      it_behaves_like 'success response'

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
end
