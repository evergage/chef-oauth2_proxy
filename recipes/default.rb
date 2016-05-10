
case node['oauth2_proxy']['install_mode']
when 'source'
  include_recipe "#{cookbook_name}::install_source"
when 'binary'
  include_recipe "#{cookbook_name}::install_binary"
end
