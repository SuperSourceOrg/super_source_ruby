require 'json'
require 'openssl'
require 'base64'

module SuperSource
  class Project
    attr_accessor :name, :api_token, :client_data, :client_token

    def initialize(name, api_token, options = {})
      @name = name
      @api_token = api_token
      @options = options
      @options[:level] ||= :error
      @client_data = self.load_client_data
      @client_token = self.load_client_token
    end

    def ensure_required!
      if SuperSource.project_root.nil?
        self.report_problem!("Could not detect a Supported Source project root in working directory or any parent " +
                "directories. Are you sure you're running this from the right place?",
            MissingProjectRoot)
        return
      end

      if !self.token_file_exists?
        self.report_problem!("Missing Supported Source token for " +
                    "project: #{ name }.#{ Exceptions.help_message }", MissingProjectToken)
        return
      end

      if !self.valid?
        self.report_problem!("Invalid Supported Source token for project: #{ name }.#{ Exceptions.help_message }",
            InvalidProjectToken)
        return
      end
    end

    def report_problem!(message, error_class)
      if @options[:level] == :warn
        warn("WARNING: " + message)
      elsif @options[:level] == :error
        raise error_class.new(message)
      end
    end

    def filename(filetype)
      "#{ SuperSource.project_supso_config_root }/projects/#{ self.name }.#{ filetype }"
    end

    def data_filename
      self.filename('json')
    end

    def load_client_data
      if File.exist?(self.data_filename)
        JSON.parse(File.read(self.data_filename))
      else
        {}
      end
    end

    def load_client_token
      if self.token_file_exists?
        File.read(self.token_filename)
      else
        nil
      end
    end

    def token_filename
      self.filename('token')
    end

    def token_file_exists?
      File.exist?(self.token_filename)
    end

    def valid?
      if !self.client_token || !self.client_data
        return false
      end

      if self.client_data['project_api_token'] != self.api_token
        return false
      end

      if !Organization.current_organization ||
          self.client_data['organization_id'] != Organization.current_organization.id
        return false
      end

      public_key = OpenSSL::PKey::RSA.new File.read("#{ SuperSource.gem_root }/lib/other/supso2.pub")
      digest = OpenSSL::Digest::SHA256.new

      public_key.verify(digest, Base64.decode64(self.client_token), self.client_data.to_json)
    end

    class << self
      attr_accessor :projects
    end

    def self.projects
      @projects ||= []
    end

    def self.add(name, api_token, options = {})
      project = Project.new(name, api_token, options)
      self.projects << project
      project.ensure_required!
    end
  end
end
