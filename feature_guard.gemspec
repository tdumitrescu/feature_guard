# -*- encoding: utf-8 -*-
require File.expand_path('../lib/feature_guard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ted Dumitrescu"]
  gem.email         = ["miscmisc@cmme.org"]
  gem.summary       = %q{Simple Redis-based feature-flagging}
  gem.description   = <<end
Turn code on or off with Redis controls, allowing simple enabled/disabled states 
as well as finer-grained percentage-based control.
end
  gem.homepage      = "https://github.com/tdumitrescu/feature_guard"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "feature_guard"
  gem.require_paths = ["lib"]
  gem.version       = FeatureGuard::VERSION

  gem.add_dependency "redis", "~> 3.0"

  gem.add_development_dependency "fakeredis", "~> 0.4"
  gem.add_development_dependency "rspec",     "~> 2.13"
end
