$:.unshift(File.dirname(__FILE__) + '/lib')
require 'whisk/version'

Gem::Specification.new do |s|
  s.name = 'whisk'
  s.version = Whisk::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = "A simple Chef cookbook dependency manager"
  s.description = s.summary
  s.author = "Mathieu Sauve-Frankel"
  s.email = "msf@kisoku.net"
  s.homepage = "http://whisk.github.com"
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md) + Dir.glob("lib/**/*")
  s.add_dependency "mixlib-log", ">= 1.3.0"
  s.add_dependency "mixlib-shellout", ">= 1.0.1.rc.1"
  s.add_development_dependency "rspec"
end


