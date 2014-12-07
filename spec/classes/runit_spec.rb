require 'spec_helper'

describe 'runit' do
  let :facts do
    { :osfamily  => 'debian' }
  end

  context 'no parameters' do
    it { should compile.with_all_deps }
    it { should contain_class('runit') }
    it { should contain_class('runit::install') }
    it { should contain_class('runit::service') }
    it { should contain_anchor('runit::begin').with(
      'before' => 'Anchor[runit::end]',
    ) }
    it { should contain_anchor('runit::end').with(
      'require' => 'Anchor[runit::begin]',
    ) }
  end
end
