# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'super_source/version'

Gem::Specification.new do |spec|
  spec.authors = ["Jeff Pickhardt"]
  spec.description = "Learn who's using your project with Super Source."
  spec.email = ["pickhardt@gmail.com"]
  spec.homepage = "http://supso.org/"
  spec.name = "super_source"
  spec.summary = "See who's using your project with Super Source."
  spec.version = SuperSource::VERSION

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "bin"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
end
