
# Create a user for the service
#
user "oauth2_proxy"

# Download the oauth2_proxy binary
#
remote_file "#{Chef::Config['file_cache_path']}/go1.4.3.linux-amd64.tar.gz" do
  source "https://storage.googleapis.com/golang/go1.4.3.linux-amd64.tar.gz"
  notifies :run, "bash[extract golang]", :immediately
  notifies :run, "bash[compile oauth2_proxy]", :immediately
end

bash "extract golang" do
  cwd "#{Chef::Config['file_cache_path']}"
  code <<-EOH
    tar -zxvf "go1.4.3.linux-amd64.tar.gz"
    mkdir go_work
  EOH
  action :nothing
end

bash "compile oauth2_proxy" do
  cwd "#{Chef::Config['file_cache_path']}"
  environment "GOROOT" => "#{Chef::Config['file_cache_path']}/go",
              "GOPATH" => "#{Chef::Config['file_cache_path']}/go_work",
              "PATH" => "#{Chef::Config['file_cache_path']}/go/bin:/bin:/usr/bin:/usr/local/bin"
  code <<-EOH
    go get github.com/bitly/oauth2_proxy
  EOH
  action :nothing
end

remote_file "/usr/local/bin/oauth2_proxy" do
  source "file://#{Chef::Config['file_cache_path']}/go_work/bin/oauth2_proxy"
  owner "root"
  group "oauth2_proxy"
  mode  0754
end

