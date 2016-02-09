require 'spec_helper'

supported_oses = {}.merge!(on_supported_os)
RspecPuppetFacts.meta_supported_os.each do |os|
  if os['operatingsystem'] =~ /windows/i
    os['operatingsystemrelease'].each do |release|
      os_string = "#{os['operatingsystem']}-#{release}"
      supported_oses[os_string] = {
        :operatingsystem => 'windows',
        :kernelversion => '6.3.9600', # Just defaulting to 2012r2
      }
    end
  end
end

describe '<%= metadata['name'] %>' do
  context 'supported operating systems' do
    supported_oses.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'without any parameters' do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('<%= metadata['name'] %>::params') }
          it { is_expected.to contain_class('<%= metadata['name'] %>::install').that_comes_before('<%= metadata['name'] %>::config') }
          it { is_expected.to contain_class('<%= metadata['name'] %>::config') }
          it { is_expected.to contain_class('<%= metadata['name'] %>::service').that_subscribes_to('<%= metadata['name'] %>::config') }

          it { is_expected.to contain_service('<%= metadata['name'] %>') }
          it { is_expected.to contain_package('<%= metadata['name'] %>').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('<%= metadata['name'] %>') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
