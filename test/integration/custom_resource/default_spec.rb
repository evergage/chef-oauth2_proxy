
describe file('/usr/local/bin/oauth2_proxy') do
  it { should be_executable }
end

describe service('oauth2_proxy_test') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/oauth2_proxy/test.conf') do
  its('content') { should match(/client_id\s=\s"someteststring"/) }
  its('content') { should match(/client_secret\s=\s"supersecret"/) }
  its('content') { should match(/upstreams\s=\s\["http:\/\/localhost:8080"\]/) }
  its('content') { should match(/email_domains\s=\s\["test.com"\]/) }
  its('content') { should match(/test\s=\s"var"/) }
end
