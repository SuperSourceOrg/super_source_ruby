require 'bundler'
require 'json'

module SupportedSource
  module Util
    def Util.deep_merge(first, second)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      first.merge(second, &merger)
    end

    def Util.pluralize(count, word)
      if count == 1
        word
      else
        "#{ word }s"
      end
    end

    def Util.require_all_gems!
      Bundler.require(:default, :development, :test, :production)
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
