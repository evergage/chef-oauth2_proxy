#
# Cookbook Name:: oauth2_proxy
# Spec:: install_binary
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'oauth2_proxy::install_binary' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'creates the oauth2 user' do 
      expect(chef_run).to create_user('oauth2_proxy')
    end

    it 'installs the binary with the ark provider' do
      expect(chef_run).to install_ark('oauth2_proxy').with(
        prefix_bin: '/usr/local/bin/',
        has_binaries: ['oauth2_proxy']
      )
    end

    it 'converges successfully' do 
      expect { chef_run }.to_not raise_error
    end
  end
end
