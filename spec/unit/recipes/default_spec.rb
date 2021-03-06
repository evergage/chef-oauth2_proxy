#
# Cookbook Name:: oauth2_proxy
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'oauth2_proxy::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'includes the install_source recipe' do
      stub_command("/usr/local/go/bin/go version | grep \"go1.5 \"").and_return(0)
      expect(chef_run).to include_recipe('oauth2_proxy::install_source')
    end

    it 'converges successfully' do 
      stub_command("/usr/local/go/bin/go version | grep \"go1.5 \"").and_return(0)
      expect { chef_run }.to_not raise_error
    end
  end
end
