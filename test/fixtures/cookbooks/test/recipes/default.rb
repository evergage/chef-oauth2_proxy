# this aims to test as much of the proxy as possible

include_recipe 'oauth2_proxy::install_binary'

oauth2_proxy_instance 'test' do
  client_id 'someteststring'
  client_secret 'supersecret'
  email_domains ['test.com']
  upstreams ['http://localhost:8080']
  extra_opts(test: 'var')
end
