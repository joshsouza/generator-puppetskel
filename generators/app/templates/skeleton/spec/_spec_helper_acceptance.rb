require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'winrm'
# require 'beaker/puppet_install_helper'

# run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

version = ENV['PUPPET_GEM_VERSION'] || '3.8.3'
hosts.each do |host|
  install_puppet(:version => version)
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    #puppet_module_install(:source => proj_root, :module_name => '<%= metadata['name'] %>')

    hosts.each do |host|
      puppet_module_install(:source => proj_root, :module_name => '<%= metadata['name'] %>')
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), :acceptable_exit_codes => [0, 1]
    end
  end
end
