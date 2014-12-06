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
    it { should contain_anchor('runit::before').with(
      'before' => 'Class[Runit::Install]',
      'notify' => 'Class[Runit::Service]',
    ) }
    it { should contain_anchor('runit::after').with(
      'require' => 'Class[Runit::Service]'
    ) }
  end
end
