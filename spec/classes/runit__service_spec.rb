require 'spec_helper'

describe 'runit::service' do
  context 'default parameters' do
    let(:facts) { {
      :osfamily => 'debian',
      :operatingsystem => 'debian'
    } }
    it { should contain_anchor('runit::service::begin').with(
      'before' => 'Anchor[runit::service::end]'
    ) }
    it { should contain_anchor('runit::service::end').with(
      'require' => 'Anchor[runit::service::begin]'
    ) }
  end

  context 'osfamily debian' do
    let(:facts) { {
      :osfamily => 'debian',
      :operatingsystem => 'debian'
    } }
    it { should contain_class('runit::service::debian') }
  end
end
