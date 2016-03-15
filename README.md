# oauth2_proxy

A cookbook which provides the [oauth2_proxy](https://github.com/bitly/oauth2_proxy) application to allow webservers to authentication against third part Oauth2 providers.

# Requirements

This cookbook requires *Chef 12.7.0* or later

# Platform

Ubuntu

# Attributes

- oauth2_proxy.source: The url to download the oauth2_proxy binary from
- oauth2_proxy.checksum: The binary checksum
- oauth2_proxy.install_mode: When to install the binary or from source

# Resources

### oauth2_proxy_instance

This resource will generate the oauth2_proxy configuration file, upstart service and will ensure that it runs.

# Installation

I am currently using this to perform authentication in nginx, and therefore must install via source until such a time as `oauth2_proxy` commit `e61fc9e7a67c85c97516ba6804cd4e0e45bc2a8c` is included in the binary release. This should not be a problem is running `oauth2_proxy` in proxy mode.

### google authentication setup

https://github.com/bitly/oauth2_proxy#google-auth-provider

### nginx authentication

```
server {
  # Proxy oauth2 endpoint to oauth2_proxy
  location /oauth2 {
    proxy_pass http://127.0.0.1:4180;
  }

  location / {
    # Require authentication
    auth_request /oauth2/auth;
    error_page 401 = /oauth2/sign_in;

    # Serve our usual content
    proxy_pass http://my_fancy_app;
  }
}
```

