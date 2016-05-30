# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'supported_source/version'

Gem::Specification.new do |spec|
  spec.authors = ["Jeff Pickhardt"]
  spec.description = "Learn who's using your project with Supported Source."
  spec.email = ["pickhardt@gmail.com"]
  spec.executables = ["supso"]
  spec.homepage = "http://supportedsource.org/"
  spec.name = "supported_source"
  spec.summary = "Learn who's using your project with Supported Source."
  spec.version = SupportedSource::VERSION

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "bin"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
end
