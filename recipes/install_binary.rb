
# Create a user for the service
#
user 'oauth2_proxy'

# Download the oauth2_proxy binary
#
ark 'oauth2_proxy' do
  url node['oauth2_proxy']['source']
  checksum node['oauth2_proxy']['checksum']
  prefix_bin '/usr/local/bin/'
  has_binaries ['oauth2-proxy']
end
