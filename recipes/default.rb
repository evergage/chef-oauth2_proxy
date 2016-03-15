
case node[:oauth2_proxy][:install_mode]
when "source" then include_recipe "#{cookbook_name}::install_source"
when "binary" then include_recipe "#{cookbook_name}::install_binary"
end

