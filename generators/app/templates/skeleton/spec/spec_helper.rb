require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

require 'simplecov'
require 'simplecov-console'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ])
end

# Enable hiera_data emulation within tests
# Thank you: http://blog.csanchez.org/2013/10/01/testing-puppet-and-hiera/
# As well as: https://teamtreehouse.com/community/using-stub-from-rspecmocks-old-should-syntax-without-explicitly-enabling-the-syntax-is-deprecated
require 'hiera-puppet-helper/rspec'
require 'hiera'
require 'puppet/indirector/hiera'

# config hiera to work with let(:hiera_data)
def hiera_stub
  config = Hiera::Config.load(hiera_config)
  config[:logger] = 'puppet'
  Hiera.new(:config => config)
end

RSpec.configure do |c|
  c.mock_framework = :rspec

  c.before(:each) do
    #Puppet::Indirector::Hiera.stub(:hiera => hiera_stub)
    allow(Puppet::Indirector::Hiera).to receive_messages(:hiera => hiera_stub)
  end
end