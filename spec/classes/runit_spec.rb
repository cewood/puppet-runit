require 'spec_helper'

describe 'runit' do
  let :facts do
    { :osfamily  => 'debian' }
  end

  context 'no parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('runit') }
    it { is_expected.to contain_class('runit::install') }
    it { is_expected.to contain_class('runit::service') }
  end
end
