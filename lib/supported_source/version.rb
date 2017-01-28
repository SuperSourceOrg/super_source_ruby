module SupportedSource
  if !defined?(SupportedSource::VERSION)
    VERSION_MAJOR = 0
    VERSION_MINOR = 10
    VERSION_PATCH = 0
    VERSION = [VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH].join('.')
  end
end
