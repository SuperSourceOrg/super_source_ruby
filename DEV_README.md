# Helpful things to remember when developing

## Publishing to Rubygems

Ensure the version number is updated (lib/supported_source/version.rb.

rspec

gem build supported_source.gemspec

gem push supported_source-VERSION.gem

## Requiring the local version of the Gem

Use something like this:

gem 'supported_source', '0.8.0', path: 'local/path/to/gem'
