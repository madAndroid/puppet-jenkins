require 'spec_helper'

describe 'jenkins::credentials' do

  let(:title) { 'mycreds' }
  let(:facts) {{
    :osfamily => 'RedHat',
    :operatingsystem => 'CentOS',
  }}
  let(:helper_cmd) { "/usr/bin/java -jar cli.jar -s http://127.0.0.1:8080 groovy /var/lib/jenkins/puppet_helper.groovy" }
  let(:pre_condition) {
    "class jenkins::cli_helper { $helper_cmd = '#{helper_cmd}' }"
  }

  describe 'with ensure is present' do
    let(:params) {{
      :ensure   => 'present',
      :password => 'mypass',
    }}
    it { should contain_exec('create-jenkins-credentials-mycreds').with({
      :command    => "#{helper_cmd} create_or_update_credentials #{title} 'mypass' '' 'Managed by Puppet' ''",
      :unless     => "#{helper_cmd} credential_info #{title} | grep #{title}",
      :tries      => '3',
      :try_sleep  => '5',
      :require    => 'Class[Jenkins::Cli_helper]',
    })}
  end

  describe 'with ensure is absent' do
    let(:params) {{
      :ensure   => 'absent',
      :password => 'mypass',
    }}
    it { should contain_exec('delete-jenkins-credentials-mycreds').with({
      :command    => "#{helper_cmd} delete_credentials #{title}",
      :tries      => '3',
      :try_sleep  => '5',
      :require    => 'Class[Jenkins::Cli_helper]',
    })}
  end

  describe 'with uuid set' do
    let(:params) {{
      :ensure   => 'present',
      :password => 'mypass',
      :uuid     => 'e94d3b98-5ba4-43b9-89ed-79a08ea97f6f',
    }}
    it { should contain_exec('create-jenkins-credentials-mycreds').with({
      :command    => "#{helper_cmd} create_or_update_credentials #{title} 'mypass' 'e94d3b98-5ba4-43b9-89ed-79a08ea97f6f' 'Managed by Puppet' ''",
      :unless     => "#{helper_cmd} credential_info #{title} | grep #{title}",
      :tries      => '3',
      :try_sleep  => '5',
      :require    => 'Class[Jenkins::Cli_helper]',
    })}
  end

end
