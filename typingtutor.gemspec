# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "typingtutor/version"

Gem::Specification.new do |gem|
  gem.name        = 'typingtutor'
  gem.version     = Typingtutor::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.summary     = "Command line typing tutor"
  gem.authors     = ["Paolo Dona"]
  gem.email       = ['paolo.dona@gmail.com']
  gem.files       = `git ls-files`.split("\n")
  gem.homepage    = 'https://github.com/paolodona/typingtutor'
  gem.license     = 'MIT'
  gem.executables = ['typingtutor']
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "highline", ['1.7.8']
  gem.add_development_dependency 'rake'
end
