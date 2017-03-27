require 'json'
require 'uri'
require 'net/http'

Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each do |file|
  require file
end

Dir[File.dirname(__FILE__) + '/super_source/*.rb'].each do |file|
  require file
end

module SuperSource
  extend ModuleVars

  env = ENV['ENV'] || "development"
  create_module_var("environment", env)

  spec = Gem::Specification.find_by_name("super_source")

  create_module_var("gem_root", spec.gem_dir)
  create_module_var("project_root", Util.detect_project_root)
  create_module_var("project_supso_config_root", SuperSource.project_root ? SuperSource.project_root + '/.supso' : nil)
  create_module_var("user_supso_config_root", "#{ Dir.home }/.supso")
  FileUtils.mkdir_p(SuperSource.user_supso_config_root)

  create_module_var("config", {})

  SuperSource::Config.load_config!
end
