require 'spec_helper'
test_on = {
  supported_os: [
    {
      'operatingsystem'        => 'Debian',
      'operatingsystemrelease' => ['9'],
      # the puppet gem
    }
  ]
}

describe 'authdns' do
  let(:node) { 'testhost.eqiad.wmnet' }
  let(:node_params) { {'cluster' => 'authdns', 'site' => 'eqiad'} }

  on_supported_os(test_on).each do |os, facts|
    context "On #{os}" do
      let(:facts) { facts }
      let(:params) { {
                       :lvs_services => {},
                       :discovery_services => {},
                       :conftool_prefix => '/conftooltest/v42',
                       :service_listeners => ['127.0.0.1', '127.0.0.2:1234'],
                       :monitor_listeners => ['[2001:db8::1]:4321', '192.0.2.1'],
                       :authdns_servers => { 'foo' => '192.0.2.1' },
                     } }
      let(:pre_condition) { [
                              'define git::clone($directory, $origin, $branch,$owner,$group) {}',
                              'define ssh::userkey($content) {}',
                              'define sudo::user($privileges) {}',
                              'class confd($prefix) {}',
                              'package{ "git": }',
                              'include ::apt',
                              'class profile::base { $notifications_enabled = "1" }',
                              'include ::profile::base'
                            ] }
      it { is_expected.to compile.with_all_deps  }
    end
  end
end
