require 'bundler'
require 'json'

module SupportedSource
  module Util
    def Util.deep_merge(first, second)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      first.merge(second, &merger)
    end

    def Util.detect_project_root
      project_root = Dir.getwd
      while true
        if project_root == ""
          project_root = nil
          break
        end

        if File.exist?(project_root + '/Gemfile') ||
            File.exist?(project_root + '/package.json') ||
            File.exist?(project_root + '.supso')
          break
        end

        detect_project_root_splits = project_root.split("/")
        detect_project_root_splits = detect_project_root_splits[0..detect_project_root_splits.length - 2]
        project_root = detect_project_root_splits.join("/")
      end

      project_root
    end

    def Util.pluralize(count, word)
      if count == 1
        word
      else
        "#{ word }s"
      end
    end

    def Util.require_all_gems!
      begin
        Bundler.require(:default, :development, :test, :production)
      rescue Gem::LoadError
        # Keep going
      end
    end

    def Util.underscore_to_camelcase(str)
      str.split('_').map{ |chunk| chunk.capitalize }.join
    end

    def Util.camelcase_to_underscore(str)
      str.gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
          .gsub(/([a-z\d])([A-Z])/,'\1_\2')
          .tr("-", "_")
          .downcase
    end
  end
end
