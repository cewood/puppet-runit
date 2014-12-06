require 'spec_helper'

describe 'runit::run' do
  context 'basic parameters' do
    let(:title) { 'someservice' }
    let(:params) { {
      :command => '/bin/somecommand',
    } }
    # it { should compile }
    it { should contain_file('/var/lib/service/someservice') }
    it { should contain_file('/var/lib/service/someservice/run') }
    it { should contain_file('/var/lib/service/someservice/log') }
    it { should contain_file('/var/lib/service/someservice/log/run') }
    it { should contain_anchor('runit::run::someservice::before').with(
      'before' => 'File[/var/log/service/someservice]',
    ) }
    it { should contain_anchor('runit::run::someservice::after').with(
      'require' => 'File[/etc/service/someservice]'
    ) }
  end

  context 'extended parameters' do
    let(:title) { 'someservice' }
    let(:params) { {
      :command        => '/bin/somecommand',
      :shell          => '/bin/zsh',
      :down           => true,
      :finish_command => '/bin/blah',
    } }
    # it { should compile.with_all_deps }
    it { should contain_file('/var/lib/service/someservice') }
    it { should contain_file('/var/lib/service/someservice/run') }
    it { should contain_file('/var/lib/service/someservice/log') }
    it { should contain_file('/var/lib/service/someservice/log/run') }
    it { should contain_file('/var/lib/service/someservice/down') }
    it { should contain_file('/var/lib/service/someservice/finish') }
  end
end
