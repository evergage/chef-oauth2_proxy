#
# Cookbook Name:: oauth2_proxy
# Spec:: install_source
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'oauth2_proxy::install_source' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'creates the oauth2 user' do 
      stub_command("/usr/local/go/bin/go version | grep \"go1.5 \"").and_return(0)
      expect(chef_run).to create_user('oauth2_proxy')
    end

    it 'includes the apt & golang recipe' do
      stub_command("/usr/local/go/bin/go version | grep \"go1.5 \"").and_return(0)
      expect(chef_run).to include_recipe('apt')
      expect(chef_run).to include_recipe('golang')
    end

    it 'installs the oauth2_proxy golang package' do
      stub_command("/usr/local/go/bin/go version | grep \"go1.5 \"").and_return(0)
      expect(chef_run).to install_golang_package('github.com/bitly/oauth2_proxy')
    end

    it 'creates the oauth2_proxy binary in the correct place' do
      stub_command("/usr/local/go/bin/go version | grep \"go1.5 \"").and_return(0)
      expect(chef_run).to create_remote_file('/usr/local/bin/oauth2_proxy')
    end

    it 'converges successfully' do 
      stub_command("/usr/local/go/bin/go version | grep \"go1.5 \"").and_return(0)
      expect { chef_run }.to_not raise_error
    end
  end
end
