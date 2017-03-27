# Helpful things to remember when developing

## Publishing to Rubygems

Ensure the version number is updated (lib/super_source/version.rb.

rspec

gem build super_source.gemspec

Make sure your ~/.gem credentials are the correct one

gem push super_source-VERSION.gem

## Requiring the local version of the Gem

Use something like this:

gem 'super_source', '0.9.6', path: 'local/path/to/gem'


## Philosophy

Super Source is split into two types of packages: the supso command line interface,
and packages included with the projects that use Super Source.

This gem, the Super Source Ruby gem, is an example of the latter.

These packages should:

1. Do the bare minimum necessary to validate a project. They should throw a human-friendly error
in case the project is not valid.

2. Include the least possible amount of third party libraries, ideally 0.

3. As much as possible, they should be read-only.

Everything else should be done by the supso command line interface. For example, updating the client tokens should be 
done in the supso library.

The supso command line interface should never be directly added as a requirement from the projects.
