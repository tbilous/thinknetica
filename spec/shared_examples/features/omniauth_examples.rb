
shared_examples 'oauth authorization' do |context_name|
  uid = '222'
  name = 'Taras Bilous'
  mail = nil

  case context_name
  when 'facebook'
    provider = :facebook
    mail = 'example@example.org'
  when 'twitter'
    provider = :twitter
  when 'github'
    provider = :github
  else
    return
  end

  context context_name do
    OmniAuth.config.mock_auth[provider] = nil
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(provider: context_name,
                                                                 uid: uid,
                                                                 info: {
                                                                   email: mail,
                                                                   name: name,
                                                                   nickname: name
                                                                 })
  end
end
