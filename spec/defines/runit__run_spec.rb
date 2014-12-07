require 'spec_helper'

describe 'runit::run' do
  context 'default parameters' do
    let(:title) { 'someservice' }
    let(:params) { {
      :command => '/bin/somecommand',
    } }
    it { should contain_anchor('runit::run::someservice::begin').with(
      'before' => 'Anchor[runit::run::someservice::end]',
    ) }
    it { should contain_anchor('runit::run::someservice::end').with(
      'require' => 'Anchor[runit::run::someservice::begin]'
    ) }
    it { should contain_file('/var/lib/service/someservice') }
    it { should contain_file('/var/lib/service/someservice/run') }
    it { should contain_file('/var/lib/service/someservice/log') }
    it { should contain_file('/var/lib/service/someservice/log/run') }
  end

  context 'non-default parameters' do
    let(:title) { 'someservice' }
    let(:params) { {
      :command        => '/bin/somecommand',
      :shell          => '/bin/zsh',
      :down           => true,
      :finish_command => '/bin/blah',
    } }
    it { should contain_file('/var/lib/service/someservice') }
    it { should contain_file('/var/lib/service/someservice/run') }
    it { should contain_file('/var/lib/service/someservice/log') }
    it { should contain_file('/var/lib/service/someservice/log/run') }
    it { should contain_file('/var/lib/service/someservice/down') }
    it { should contain_file('/var/lib/service/someservice/finish') }
  end
end
