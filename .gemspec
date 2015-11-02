# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "service_registry/version"

Gem::Specification.new do |spec|
  spec.name          = "service_registry"
  spec.version       = ServiceRegistry::VERSION
  spec.authors       = ["Ernst van Graan"]
  spec.email         = ["ernst.van.graan@hetzner.co.za"]

  spec.summary       = %q{Service Registry}
  spec.description   = %q{Service Registry}
  spec.homepage      = "https://github.com/hetznerZA/service_registry"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "cucumber", "~> 2.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "rspec-expectations", "~> 3.3"
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'roxml'
end
