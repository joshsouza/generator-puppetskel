require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'winrm'
require 'beaker/puppet_install_helper'

# If using non-windows patched beaker, we'd do the below
# require 'beaker/puppet_install_helper'
# run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

# Instead, we have to manually install Puppet

version = ENV['PUPPET_GEM_VERSION'] || '1.4.2'
ENV['PUPPET_INSTALL_TYPE'] = 'agent'
ENV['PUPPET_INSTALL_VERSION'] = version
run_puppet_install_helper()

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    #puppet_module_install(:source => proj_root, :module_name => 'fourpointx')

    hosts.each do |host|
      globroot="#{proj_root}/spec/fixtures/modules"
      Dir.glob("#{globroot}/*").select {|f| File.directory? f}.each do |f|
        mod_name=f.split(/[\\\/]/)[-1]
        puppet_module_install(:source => "#{globroot}/#{mod_name}", :module_name => mod_name )
      end
    end
  end
end