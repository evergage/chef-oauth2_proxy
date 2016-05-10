# this is needed to install git in golang
include_recipe 'apt'

# installing the golang
include_recipe 'golang'

# Create a user for the service
#
user 'oauth2_proxy'

# Download the oauth2_proxy binary
#

golang_package 'github.com/bitly/oauth2_proxy'

remote_file '/usr/local/bin/oauth2_proxy' do
  source "file://#{node['go']['gobin']}/oauth2_proxy"
  owner 'root'
  group 'oauth2_proxy'
  mode 0754
end
