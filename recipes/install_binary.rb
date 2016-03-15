
# Create a user for the service
#
user "oauth2_proxy"

# Download the oauth2_proxy binary
#
tarball_path = "#{Chef::Config['file_cache_path']}/oauth2_proxy.tgz"

remote_file tarball_path do
  source node[:oauth2_proxy][:source]
  checksum node[:oauth2_proxy][:checksum]
  notifies :run, "bash[extract #{tarball_path}]", :immediately
end

bash "extract #{tarball_path}" do
  cwd "#{Chef::Config['file_cache_path']}"
  code <<-EOH
    tar --strip-components=1 -xzf #{tarball_path}
  EOH
  action :nothing
end

remote_file "/usr/local/bin/oauth2_proxy" do
  source "file://#{Chef::Config['file_cache_path']}/oauth2_proxy"
  owner "oauth2_proxy"
  group "oauth2_proxy"
  mode  0754
end

