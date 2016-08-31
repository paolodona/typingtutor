Gem::Specification.new do |gem|
  gem.name        = 'typingtutor'
  gem.version     = '1.0.2'
  gem.date        = '2016-08-31'
  gem.summary     = "Command line typing tutor"
  gem.authors     = ["Paolo Dona"]
  gem.email       = 'paolo.dona@gmail.com'
  gem.files       = %w{lib/typingtutor.rb
                       lib/typingtutor/line.rb
                       lib/typingtutor/runner.rb
                       bin/typingtutor}
  gem.homepage    = 'https://github.com/paolodona/typingtutor'
  gem.license     = 'MIT'
  gem.executables << 'typingtutor'
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "highline", ['1.7.8']
end
