require 'json'

module SupportedSource
  class Organization
    attr_accessor :name, :id

    @@current_organization = nil

    def initialize(name, id)
      @name = name
      @id = id
    end

    def self.current_organization_filename
      "#{ SupportedSource.project_supso_config_root }/current_organization.json"
    end

    def self.current_organization_from_file
      organization_data = {}
      begin
        organization_data = JSON.parse(File.read(Organization.current_organization_filename))
        organization_data = {} if !organization_data.is_a?(Object)
      rescue
        organization_data = {}
      end

      if organization_data['id']
        Organization.new(organization_data['name'], organization_data['id'])
      else
        nil
      end
    end

    def self.current_organization
      @@current_organization ||= Organization.current_organization_from_file
    end
  end
end
