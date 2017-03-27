require 'yaml'

module SuperSource
  class User
    attr_accessor :email, :name, :id, :auth_token

    @@current_user = nil

    def initialize(email, name, id, auth_token = nil)
      @email = email
      @name = name
      @id = id
      @auth_token = auth_token
    end

    def self.current_user_filename
      "#{ SuperSource.user_supso_config_root }/current_user.json"
    end

    def self.current_user_from_file
      if !File.exist?(User.current_user_filename)
        return nil
      end

      user_data = {}
      begin
        user_data = JSON.parse(File.read(User.current_user_filename))
        user_data = {} if !user_data.is_a?(Object)
      rescue JSON::ParserError => err
        user_data = {}
      end

      if user_data['email'] || user_data['auth_token']
        User.new(user_data['email'], user_data['name'], user_data['id'], user_data['auth_token'])
      else
        nil
      end
    end

    def self.current_user
      @@current_user ||= User.current_user_from_file
    end
  end
end
