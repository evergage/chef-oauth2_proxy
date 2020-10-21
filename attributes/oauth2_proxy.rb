# Only works with OAuth2 Proxy 3.0.0+.
# There is no default version, users of cookbook must define these themselves.
#default['oauth2_proxy']['source'] = 'https://github.com/.../oauth2_proxy...tar.gz'
#default['oauth2_proxy']['checksum'] = '...'
default['oauth2_proxy']['install_mode'] = 'source'

default['oauth2_proxy']['user'] = 'oauth2_proxy'
default['oauth2_proxy']['group'] = 'oauth2_proxy'
