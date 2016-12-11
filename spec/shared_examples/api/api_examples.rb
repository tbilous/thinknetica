shared_examples 'success response' do
  it 'returns success response' do
    expect(response).to be_success
  end
end

shared_examples 'unauthorized' do
  context 'unauthorized' do
    options ||= {}
    http_method ||= :get

    it 'returns 401 status if there is no access_token' do
      do_request(url, http_method, options)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(url, http_method, options.merge(access_token: '123'))
      expect(response.status).to eq 401
    end
  end
end
