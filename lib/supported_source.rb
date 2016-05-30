require 'json'
require 'uri'
require 'net/http'

Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each do |file|
  require file
end

Dir[File.dirname(__FILE__) + '/supported_source/*.rb'].each do |file|
  require file
end

module SupportedSource
  extend ModuleVars

  env = ENV['ENV'] || "development"
  create_module_var("environment", env)

  spec = Gem::Specification.find_by_name("supported_source")

  create_module_var("gem_root", spec.gem_dir)

  detect_project_root = Dir.getwd
  while true
    if detect_project_root == ""
      raise "Could not find a Gemfile in the current working directory or any parent directories. Are you sure you're running this from the right place?"
    end

    if File.exist?(detect_project_root + '/Gemfile')
      break
    end

    detect_project_root_splits = detect_project_root.split("/")
    detect_project_root_splits = detect_project_root_splits[0..detect_project_root_splits.length - 2]
    detect_project_root = detect_project_root_splits.join("/")
  end
  create_module_var("project_root", detect_project_root)
  create_module_var("project_supso_config_root", detect_project_root + '/.supso')
  create_module_var("user_supso_config_root", "#{ Dir.home }/.supso")
  FileUtils.mkdir_p(SupportedSource.user_supso_config_root)
  create_module_var("operating_mode", 'default')
  create_module_var("supso_api_root", "https://supportedsource.org/api/v1/")

  create_module_var("config", {})

  SupportedSource::Config.load_config!
end
