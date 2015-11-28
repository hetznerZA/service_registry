require 'uri'
require 'soar_sr'
require 'json'
require 'soap4juddi'
require 'jsender'

module ServiceRegistry
  module Test
    class SoarSrImplementation < ServiceRegistry::Providers::BootstrappedProvider
      include ServiceRegistry::Providers::DssAssociate

      def initialize(uri, fqdn, company_name, credentials)
        @uri = uri
        @fqdn = fqdn
        @company_name = company_name
        @credentials = credentials
        @soar_sr = SoarSr::ServiceRegistry.new(uri, fqdn, company_name, credentials)
      end

      def fix
        @soar_sr = SoarSr::ServiceRegistry.new(@uri, @fqdn, @company_name, @credentials)
      end

      def break
        @soar_sr = SoarSr::ServiceRegistry.new(@uri, @fqdn, @company_name, { 'username' => 'invalid', 'password' => 'none' })
      end

      def authorized=(value)
        @soar_sr = SoarSr::ServiceRegistry.new(@uri, @fqdn, @company_name, @credentials) if value
        @soar_sr = SoarSr::ServiceRegistry.new(@uri, @fqdn, @company_name, { 'username' => 'invalid', 'password' => 'none' }) if not value
      end

      def service_by_id(id)
        @soar_sr.services.service_by_id(id)
      end 

      def register_service(service)
        @soar_sr.services.register_service(service)
      end

      def service_registered?(service)
        @soar_sr.services.service_registered?(service)
      end

      def deregister_service(service)
        @soar_sr.services.deregister_service(service)
      end

      def add_service_uri(service, uri)
        @soar_sr.services.add_service_uri(service, uri)
      end

      def service_uris(service)
        @soar_sr.services.service_uris(service)
      end

      def remove_uri_from_service(service, uri)
        @soar_sr.services.remove_uri_from_service(service, uri)
      end

      def configure_meta_for_service(service, meta)
        @soar_sr.services.configure_meta_for_service(service, meta)
      end

      def meta_for_service(service)
        @soar_sr.services.meta_for_service(service)
      end      

      def register_service_definition(service, definition)
        @soar_sr.service_definitions.register_service_definition(service, definition)
      end

      def service_definition_for_service(service)
        @soar_sr.service_definitions.service_definition_for_service(service)
      end

      def deregister_service_definition(service)
        @soar_sr.service_definitions.deregister_service_definition(service)
      end

      def reset_domain_perspectives
        @soar_sr.domain_perspectives.delete_all_domain_perspectives
      end

      def list_domain_perspectives
        @soar_sr.domain_perspectives.list_domain_perspectives
      end

      def domain_perspective_registered?(domain_perspective)
        @soar_sr.domain_perspectives.domain_perspective_registered?(domain_perspective)
      end

      def register_domain_perspective(domain_perspective)
        @soar_sr.domain_perspectives.register_domain_perspective(domain_perspective)
      end

      def deregister_domain_perspective(domain_perspective)
        @soar_sr.domain_perspectives.deregister_domain_perspective(domain_perspective)
      end

      def configure_meta_for_domain_perspective(type, domain_perspective, meta)
        @soar_sr.domain_perspectives.configure_meta_for_domain_perspective(type, domain_perspective, meta)
      end

      def meta_for_domain_perspective(type, domain_perspective)
        @soar_sr.domain_perspectives.meta_for_domain_perspective(type, domain_perspective)
      end

      def delete_all_domain_perspective_associations(domain_perspective)
        @soar_sr.associations.delete_all_domain_perspective_associations(domain_perspective)
      end

      def team_registered?(domain_perspective)
        @soar_sr.teams.team_registered?(domain_perspective)
      end

      def register_team(domain_perspective)
        @soar_sr.teams.register_team(domain_perspective)
      end

      def deregister_team(domain_perspective)
        @soar_sr.teams.deregister_team(domain_perspective)
      end      

      def list_service_components(domain_perspective = nil)
        @soar_sr.service_components.list_service_components(domain_perspective)
      end

      def delete_all_service_components
        @soar_sr.service_components.delete_all_service_components
      end

      def service_component_registered?(service_component)
        @soar_sr.service_components.service_component_registered?(service_component)
      end

      def register_service_component(service_component)
        @soar_sr.service_components.register_service_component(service_component)
      end

      def deregister_service_component(service_component)
        @soar_sr.service_components.deregister_service_component(service_component)
      end

      def configure_service_component_uri(service_component, uri)
        @soar_sr.service_components.configure_service_component_uri(service_component, uri)
      end

      def service_component_uri(service_component)
        @soar_sr.service_components.service_component_uri(service_component)
      end   

      def service_component_has_domain_perspective_associations?(service_component)
        @soar_sr.associations.service_component_has_domain_perspective_associations?(service_component)
      end

      def associate_service_component_with_service(service, access_point, description = '')
        @soar_sr.associations.associate_service_component_with_service(service, access_point, description = '')
      end

      def associate_service_component_with_domain_perspective(service_component, domain_perspective)
        @soar_sr.associations.associate_service_component_with_domain_perspective(service_component, domain_perspective)
      end

      def associate_service_with_domain_perspective(service, domain_perspective)
        @soar_sr.associations.associate_service_with_domain_perspective(service, domain_perspective)
      end

      def disassociate_service_component_from_domain_perspective(domain_perspective, service_component)
        @soar_sr.associations.disassociate_service_component_from_domain_perspective(domain_perspective, service_component)
      end

      def disassociate_service_from_domain_perspective(domain_perspective, service)
        @soar_sr.associations.disassociate_service_from_domain_perspective(domain_perspective, service)
      end

      def domain_perspective_associations(domain_perspective)
        @soar_sr.associations.domain_perspective_associations(domain_perspective)
      end

      def check_dss(name)
        @soar_sr.check_dss(name)
      end

      def query_service_by_pattern(pattern)
        @soar_sr.search.query_service_by_pattern(pattern)
      end

      def search_for_service(pattern)
        @soar_sr.search.search_for_service(pattern)
      end     

      def search_domain_perspective(domain_perspective, pattern)
        @soar_sr.search.search_domain_perspective(domain_perspective, pattern)
      end      
    end
  end
end
