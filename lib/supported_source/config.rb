module SupportedSource
  class Config
    def self.load_config!
      if !SupportedSource.project_supso_config_root
        return
      end

      configs_to_load = ["/config.json"]
      configs_to_load.each do |relative_path|
        config_path = SupportedSource.project_supso_config_root + relative_path
        loaded_config = File.exist?(config_path) ? JSON.parse(File.read(config_path)) : {}
        SupportedSource.config = Util.deep_merge(SupportedSource.config, loaded_config)
      end
    end
  end
end
