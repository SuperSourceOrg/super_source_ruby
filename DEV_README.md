# Helpful things to remember when developing

## Publishing to Rubygems

Ensure the version number is updated (lib/supported_source/version.rb.

rspec

gem build supported_source.gemspec

Make sure your ~/.gem credentials are the correct one

gem push supported_source-VERSION.gem

## Requiring the local version of the Gem

Use something like this:

gem 'supported_source', '0.8.0', path: 'local/path/to/gem'


## Philosophy

Supported Source is split into two types of packages: the supso command line interface,
and packages included with the projects that use Supported Source.

This gem, the Supported Source Ruby gem, is an example of the latter.

These packages should:

1. Do the bare minimum necessary to validate a project. They should throw a human-friendly error
in case the project is not valid.

2. Include the least possible amount of third party libraries, ideally 0.

3. As much as possible, they should be read-only.

Everything else should be done by the supso command line interface. For example, updating the client tokens should be 
done in the supso library.

The supso command line interface should never be directly added as a requirement from the projects.
