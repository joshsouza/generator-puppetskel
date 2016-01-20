require 'rubygems'
require 'bundler/setup'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet/version'
require 'puppet/vendor/semantic/lib/semantic' unless Puppet.version.to_f < 3.6
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'
require 'rubocop/rake_task'

# These gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

RuboCop::RakeTask.new

exclude_paths = [
  'bundle/**/*',
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*'
]

# Coverage from puppetlabs-spec-helper requires rcov which
# doesn't work in anything since 1.8.7
Rake::Task[:coverage].clear

Rake::Task[:lint].clear

PuppetLint.configuration.relative = true
PuppetLint.configuration.disable_80chars
# Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
# http://puppet-lint.com/checks/class_parameter_defaults/
PuppetLint.configuration.disable_class_parameter_defaults
# http://puppet-lint.com/checks/class_inherits_from_params_class/
PuppetLint.configuration.disable_class_inherits_from_params_class
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
end

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance, :os, :destroy, :provision) do |t, task_args|
  Rake::Task[:spec_prep].invoke
  task_args.with_defaults(:os => "default", :destroy => "onpass", :provision => "yes")
  os = task_args[:os]

  case os
  when 'centos6'
    ENV['BEAKER_set']='centos-66-x64'
  when 'centos7'
    ENV['BEAKER_set']='centos-7-x64'
  when "debian"
    ENV['BEAKER_set']='debian-78-x64'
  when "ubuntu12"
    ENV['BEAKER_set']='ubuntu-1204-x64'
  when "ubuntu14"
    ENV['BEAKER_set']='ubuntu-1404-x64'
  when "windows2012"
    ENV['BEAKER_set']='windows-server-2012r2'
  else
    puts "Using the default nodeset"
  end
  ENV['BEAKER_destroy']=task_args[:destroy]
  ENV['BEAKER_provision']=task_args[:provision]
  t.pattern = 'spec/acceptance'
end
Rake::Task[:acceptance].enhance do
  Rake::Task[:spec_clean].invoke
end

desc 'Populate CONTRIBUTORS file'
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

desc 'Run syntax, lint, and spec tests.'
task :test => [
  :metadata_lint,
  :syntax,
  :lint,
  :rubocop,
  :spec
]

RuboCop::RakeTask.new(:rubocop_debug) do |t|
  t.options = %w(-d)
end
