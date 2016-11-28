shared_context 'oauth', users: true do
  let!(:user) { create(:user) }
  let(:facebook) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456',
                                          info: { name: 'John Dow', email: user.email }) }
end
