require 'spec_helper'

describe 'runit::install' do
  context '$::osfamily debian' do
    let(:facts) { {
      :osfamily  => 'Debian'
    } }
    it { should contain_class('runit::install::debian') }
  end
end
