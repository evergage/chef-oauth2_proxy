
require 'securerandom'

property :listen_address,
         kind_of: String,
         default: '127.0.0.1'

property :listen_port,
         kind_of: Integer,
         default: 4180

property :listen_uri,
         kind_of: String,
         default: '/oauth2'

property :client_id,
         kind_of: String,
         coerce: proc { |value| Common::Delegator::ObfuscatedType.new(value) },
         required: true

property :client_secret,
         kind_of: String,
         coerce: proc { |value| Common::Delegator::ObfuscatedType.new(value) },
         required: true

property :redirect_url,
         kind_of: String

property :proxy_prefix,
         kind_of: String,
         default: '/oauth2'

property :upstreams,
         kind_of: Array,
         default: []

property :email_domains,
         kind_of: Array,
         required: true

property :request_logging,
         kind_of: [TrueClass, FalseClass],
         default: false

property :pass_access_token,
         kind_of: [TrueClass, FalseClass],
         default: true

property :pass_basic_auth,
         kind_of: [TrueClass, FalseClass],
         default: true

property :pass_host_header,
         kind_of: [TrueClass, FalseClass],
         default: true

property :custom_templates_dir,
         kind_of: String

property :cookie_name,
         kind_of: String,
         default: '_oauth2_proxy'

property :cookie_secret,
         coerce: proc { |value| Common::Delegator::ObfuscatedType.new(value) },
         kind_of: String,
         default: lazy {
           Chef::Log.warn "#{self} setting random cookie_secret, this may break load balancing."
           SecureRandom.hex
         }

property :cookie_domain,
         kind_of: String

property :cookie_expire,
         kind_of: String,
         default: '12h'

property :cookie_refresh,
         kind_of: String,
         default: '1h'

property :cookie_secure,
         kind_of: [TrueClass, FalseClass],
         default: true

property :cookie_httponly,
         kind_of: [TrueClass, FalseClass],
         default: true

property :oauth_provider,
         kind_of: String,
         default: 'google'

property :enabled,
         kind_of: [TrueClass, FalseClass],
         default: true

property :start_when_enabled,
         kind_of: [TrueClass, FalseClass],
         default: false

property :extra_opts,
         kind_of: Hash,
         default: {}

action :create do
  directory '/etc/oauth2_proxy' do
    owner node['oauth2_proxy']['user']
    group node['oauth2_proxy']['group']
    mode 0750
  end

  config = new_resource.to_hash

  template "/etc/oauth2_proxy/#{name}.conf" do
    source 'oauth2_proxy.conf.erb'
    owner node['oauth2_proxy']['user']
    group node['oauth2_proxy']['group']
    mode 0640
    cookbook 'oauth2_proxy'
    sensitive true
    variables config
    if new_resource.enabled
      notifies :restart, "service[oauth2_proxy_#{new_resource.name}]"
    end
  end

  template "/etc/init/oauth2_proxy_#{new_resource.name}.conf" do
    source 'oauth2_service.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    cookbook 'oauth2_proxy'
    variables config_path: "/etc/oauth2_proxy/#{new_resource.name}.conf",
              user: node['oauth2_proxy']['user'],
              name: new_resource.name,
              extra_opts: new_resource.extra_opts
    if new_resource.enabled
      notifies :restart, "service[oauth2_proxy_#{new_resource.name}]"
    end
  end

  service "oauth2_proxy_#{new_resource.name}" do
    # Since we install only the upstart scripts, make sure Chef doesn't try to use SysV or other provider
    provider Chef::Provider::Service::Upstart
    action new_resource.enabled ? (new_resource.start_when_enabled ? [:enable, :start] : :enable) : :disable
  end
end

action :delete do
  service "oauth2_proxy_#{new_resource.name}" do
    action [:stop, :disable]
  end

  template "/etc/oauth2_proxy/#{new_resource.name}.conf" do
    action :delete
  end

  template "/etc/init/oauth2_proxy_#{new_resource.name}.conf" do
    action :delete
  end
end
