require 'spec_helper'

describe 'runit::install::debian' do
  context 'default resources' do
    # Need to specify an osfamily so we don't error out
    let :facts do
      { :osfamily  => 'debian' }
    end

    it { should compile.with_all_deps }
    it { should contain_package('runit').with(
      'ensure' => 'installed',
    ) }
  end
end
