
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

# shared_examples 'oauth_example_facebook_invalid' do |context_name|
#   context context_name do
#     OmniAuth.config.mock_auth[":#{context_name}"] = :credentials_are_invalid
#   end
# end
#
# shared_examples 'oauth_example_twitter_invalid' do
#   OmniAuth.config.mock_auth[:twitter]  = :credentials_are_invalid
# end
#
# shared_examples 'oauth_example_github_invalid' do
#   OmniAuth.config.mock_auth[:github]  = :credentials_are_invalid
# end
