lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'succubus/version'

Gem::Specification.new do |s|
  s.name        = 'succubus'
  s.version     = Succubus::VERSION
  s.summary     = 'A random generator based on a generalised Backus-Naur Form grammar'
  s.description = <<-EOD
    Succubus is a generator which takes stochastic paths through a 
    generalised Backus-Naur Form grammar to produce random text.

    See the examples for details.
    EOD
  s.files       = Dir['lib/**/*', 'Rakefile', 'README.md']
  s.author      = 'Chris Howlett'
  s.homepage    = 'https://github.com/asilano/succubus'
  
  s.test_files  = Dir.glob('{test,spec}/**/*')
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'coveralls', :require => false
end
  