require 'spec_helper'

describe 'runit::install', :type => 'class' do
  context 'no parameters' do
    let(:facts) { {
      :osfamily  => 'Debian'
    } }
    it { should contain_class('runit::install::debian') }
  end

  context 'package name specified' do
    let(:facts) { {
      :osfamily  => 'RedHat'
    } }
    it { should contain_class('runit::install::redhat') }
  end

  context 'default resources' do
    # Need to specify an osfamily so we don't error out
    let :facts do
      { :osfamily  => 'debian' }
    end

    it { should compile.with_all_deps }
    it { should contain_file('/etc/service').with(
      'ensure' => 'directory',
      'mode' => '0755',
    ) }
    it { should contain_file('/var/lib/service').with(
      'ensure' => 'directory',
      'mode' => '0755',
    ) }
  end
end
