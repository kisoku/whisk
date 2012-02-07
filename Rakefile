$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'whisk/version'
require 'rspec/core/rake_task'

GEM_NAME = 'whisk'
GEM_VERSION = Whisk::VERSION

desc "Build #{GEM_NAME} gem"
task :build do
  system "gem build #{GEM_NAME}.gemspec"
end

desc "Push #{GEM_NAME} to rubygems.org"
task :push => :build do
  system "gem push #{GEM_NAME}-#{GEM_VERSION}.gem"
end

desc "Clean up build gems"
task :clean do
  system "rm #{GEM_NAME}-#{GEM_VERSION}.gem"
end

desc "Run rspec tests"
RSpec::Core::RakeTask.new 
