def do_request(url, http_method = :get, options)
  send(http_method, url, params: { format: :json }.merge(options))
end
