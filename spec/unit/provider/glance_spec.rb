require 'puppet'
require 'spec_helper'
require 'puppet/provider/glance'
require 'tempfile'

describe Puppet::Provider::Glance do

  def klass
    described_class
  end

  let :credential_hash do
    {
      'auth_url'     => 'https://192.168.56.210:5000/v3/',
      'project_name' => 'admin_tenant',
      'username'     => 'admin',
      'password'     => 'password',
      'region_name'  => 'Region1',
    }
  end

  let :auth_endpoint do
    'https://192.168.56.210:5000/v3/'
  end

  let :credential_error do
    /Glance types will not work/
  end

  after :each do
    klass.reset
  end

  describe 'when determining credentials' do

    it 'should fail if config is empty' do
      conf = {}
      klass.expects(:glance_conf).returns(conf)
      expect do
        klass.glance_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not have keystone_authtoken section.' do
      conf = {'foo' => 'bar'}
      klass.expects(:glance_conf).returns(conf)
      expect do
        klass.glance_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not contain all auth params' do
      conf = {'keystone_authtoken' => {'invalid_value' => 'foo'}}
      klass.expects(:glance_conf).returns(conf)
      expect do
       klass.glance_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should use specified uri in the auth endpoint' do
      conf = {'keystone_authtoken' => credential_hash}
      klass.expects(:glance_conf).returns(conf)
      expect(klass.get_auth_endpoint).to eq(auth_endpoint)
    end

  end

end
