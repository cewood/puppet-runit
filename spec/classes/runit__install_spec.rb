require 'spec_helper'

describe 'runit::install', :type => 'class' do
  let(:facts) { {
    :osfamily  => 'RedHat'
  } }
  context 'no parameters' do
    let(:params) { {} }
    let(:facts) { {
      :osfamily  => 'Debian'
    } }
    it {
      should contain_package('runit').with( {
        'ensure'   => 'installed',
      } )
    }
  end
  context 'package name specified' do
    let(:params) { {
    } }
    let(:facts) { {
      :osfamily  => 'RedHat'
    } }
    it {
      should contain_package('runit').with( {
        'ensure'   => 'installed',
        'provider' => 'rpm',
      } )
    }
  end
end
