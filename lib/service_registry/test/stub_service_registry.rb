require 'uri'
require 'jsender'

module ServiceRegistry
  module Test
    class StubServiceRegistry < ServiceRegistry::Providers::BootstrappedProvider
      include ServiceRegistry::Providers::DssAssociate
      include Jsender
      
      attr_reader :dss, :services, :broken, :service_component_associations, :contacts
      attr_writer :authorized

      def initialize(uri, fqdn, company_name, credentials)
        @authorized = true
        @meta = {}
        @services = {}
        @domain_perspectives = []
        @service_components = []
        @available = false
        @broken = false
        @service_component_associations = {}
        @service_associations = {}
        @service_uris = {}
        @contacts = {}
      end

      def register_service(service)
        return fail('not authorized') if not @authorized
        return fail('failure registering service') if @broken
        return fail('no service provided') if service.nil? or service['name'].nil?
        return fail('invalid service provided') if ((not service.is_a? Hash) or (service['name'].strip == ""))
        return fail('service already exists') if not @services[service['name']].nil?
        service['name'] = service['name'].downcase
        @services[service['name']] = service
        success('service registered')
      end

      def query_service_by_pattern(pattern)
        result = {}
        @services.each do |key, service|
          result[service['name']] = service if service['description'].include?(pattern) and check_dss(service)
        end
        success_data({ 'services' => result })
      end

      def reset_domain_perspectives
        @domain_perspectives = []
        success
      end

      def list_domain_perspectives
        return fail('failure listing domain perspectives') if @broken
        domain_perspectives = {}
        @domain_perspectives.each do |name|
          domain_perspectives[name] = {'id' => name, 'name' => name}
        end
        success_data({ 'domain_perspectives' => @domain_perspectives == [] ? {} : domain_perspectives})
      end

      def list_service_components(domain_perspective = nil)
        return fail('failure retrieving service components') if @broken
        if domain_perspective and (not @domain_perspectives.include?(domain_perspective))
          return success('unknown domain perspective provided')
        end
        return success_data({ 'service_components' => @service_components }) if domain_perspective.nil?
        result = domain_perspective_associations(domain_perspective)
        success_data({ 'service_components' => result['data']['associations'] })
      end

      def break
        @broken = true
        success
      end

      def fix
        @broken = false
        success
      end

      def register_team(team)
        register_domain_perspective(team.downcase)
      end

      def register_domain_perspective(domain_perspective)
        return fail('not authorized') if not @authorized
        return fail('failure registering domain perspective') if @broken
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective and domain_perspective.strip == "")
        if not @domain_perspectives.include?(domain_perspective)
          @domain_perspectives << domain_perspective
        else
          return fail('domain perspective already exists')
        end
        success('domain perspective registered')
      end

      def domain_perspective_associations(domain_perspective)
        associated = []
        @service_component_associations.each do |service_component, associations|
          associated << service_component if associations['domain_perspectives'] and associations['domain_perspectives'].include?(domain_perspective)
        end
        success_data({'associations' => associated})
      end

      def does_service_component_have_domain_perspectives_associated?(service_component)
        return false if not @service_component_associations[service_component]
        return false if not @service_component_associations[service_component]['domain_perspectives']
        success_data({'associated' => (@service_component_associations[service_component]['domain_perspectives'].count > 0)})
      end

      def service_component_domain_perspective_associations(service_component)
        return success_data({'associations' => @service_component_associations[service_component]['domain_perspectives']}) if @service_component_associations[service_component] and @service_component_associations[service_component]['domain_perspectives']
        success_data({'associations' => []})
      end

      def service_domain_perspective_associations(service)
        return success_data({'associations' => @service_associations[service]['domain_perspectives']}) if @service_associations[service] and @service_associations[service]['domain_perspectives']
        success_data({'associations' => []})
      end

      def deregister_domain_perspective(domain_perspective)
        return fail('not authorized') if not @authorized
        return fail('failure deregistering domain perspective') if @broken
        if not @domain_perspectives.include?(domain_perspective)
          return success('unknown domain perspective provided')
        end
        return fail('domain perspective has associations') if does_domain_perspective_have_service_components_associated?(domain_perspective)
        @domain_perspectives.delete(domain_perspective)
        return success('domain perspective deregistered')
      end

      def register_service_component(service_component)
        return fail('not authorized') if not @authorized
        return fail('failure registering service component') if @broken
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component and service_component.strip == "")
        if not @service_components.include?(service_component)
          @service_components << service_component
          return success('service component registered')
        else
          return success('service component already exists')
        end
      end

      def deregister_service(service)
        return fail('not authorized') if not @authorized
        return fail('failure deregistering service') if @broken
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return success('unknown service provided') if @services[service].nil?
        @services.delete(service)
        success('service deregistered')
      end

      def deregister_service_component(service_component)
        return fail('not authorized') if not @authorized
        return fail('failure deregistering service component') if @broken
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component and service_component.strip == "")
        if @service_components.include?(service_component)
          return fail('service component has service associations') if does_service_component_have_services_associated?(service_component)
          return fail('service component has domain perspective associations') if does_service_component_have_domain_perspectives_associated?(service_component)
          @service_components.delete(service_component)
          return success('service component deregistered')
service component has domain perspective associations
        else
          return success('unknown service component provided')
        end
      end

      def delete_domain_perspective_service_component_associations(domain_perspective)
        @service_component_associations.each do |service_component, associations|
          associations['domain_perspectives'].delete(domain_perspective) if associations['domain_perspectives'] and associations['domain_perspectives'].include(domain_perspective)
        end
        success
      end

      def associate_service_component_with_service(service, service_component)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure associating service component with service') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['services'] ||= []
        @service_uris[service] ||= []
        @service_uris[service] << service_component
        return fail('already associated') if @service_component_associations[service_component]['services'].include?(service)
        @service_component_associations[service_component]['services'] << service
        success
      end

      def associate_service_component_with_domain_perspective(service_component, domain_perspective)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure associating service component with domain perspective') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['domain_perspectives'] ||= []
        return fail('already associated') if @service_component_associations[service_component]['domain_perspectives'].include?(domain_perspective)
        @service_component_associations[service_component]['domain_perspectives'] << domain_perspective
        success
      end

      def associate_service_with_domain_perspective(service, domain_perspective)
        return fail('not authorized') if not @authorized
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure associating service with domain perspective') if @broken

        @service_associations[service] ||= {}
        @service_associations[service]['domain_perspectives'] ||= []
        return fail('already associated') if @service_associations[service]['domain_perspectives'].include?(domain_perspective)
        @service_associations[service]['domain_perspectives'] << domain_perspective
        success
      end

      def disassociate_service_component_from_domain_perspective(domain_perspective, service_component)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure disassociating service component from domain perspective') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['domain_perspectives'] ||= []
        return fail('not associated') if not @service_component_associations[service_component]['domain_perspectives'].include?(domain_perspective)
        @service_component_associations[service_component]['domain_perspectives'].delete(domain_perspective)
        success
      end

      def disassociate_service_from_domain_perspective(domain_perspective, service)
        return fail('not authorized') if not @authorized
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure disassociating service from domain perspective') if @broken

        @service_associations[service] ||= {}
        @service_associations[service]['domain_perspectives'] ||= []
        return fail('not associated') if not @service_associations[service]['domain_perspectives'].include?(domain_perspective)
        @service_associations[service]['domain_perspectives'].delete(domain_perspective)
        success
      end

      def delete_all_service_components
        @service_components = []
        success
      end

      def delete_all_domain_perspective_associations(domain_perspective)
        @service_component_associations = {}
        @service_associations = {}
      end

      def configure_service_component_uri(service_component, uri)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('unknown service component provided') if not @service_components.include?(service_component)
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        return fail('failure configuring service component') if @broken
        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['uri'] = uri
        success
      end

      def service_component_uri(service_component)
        return fail('unknown service component provided') if not @service_components.include?(service_component)
        return success_data({'uri' => nil}) if (not @service_component_associations[service_component]) or (not @service_component_associations[service_component]['uri'])
        success_data({'uri' => @service_component_associations[service_component]['uri']})
      end

      def register_service_definition(service, service_definition)
        return fail('not authorized') if not @authorized
        return fail('failure registering service definition') if @broken
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if service.strip == ""
        return fail('unknown service provided') if @services[service].nil?
        return fail('no service definition provided') if service_definition.nil?
        return fail('invalid service definition provided') if service_definition.nil? or (not service_definition.include?("wadl"))

        @services[service]['definition'] = service_definition
        success('service definition registered')
      end

      def deregister_service_definition(service)
        return fail('not authorized') if not @authorized
        return fail('invalid service provided') if service.nil? or (service.strip == "")
        return fail('unknown service provided') if @services[service].nil?
        @services[service].delete('definition')
        success('service definition deregistered')
      end

      def service_registered?(service)
        success_data({'registered' => (not (@services[service].nil?))})
      end

      def service_definition_for_service(service)
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('unknown service provided') if @services[service].nil?
        return fail('service has no definition') if @services[service]['definition'].nil?
        return success_data({'definition' => @services[service]['definition']}) if (not service.nil?) and (not @services[service].nil?)
        success_data({'definition' => nil})
      end

      def search_for_service(pattern)
        return fail('no pattern provided') if pattern.nil?
        return fail('invalid pattern provided') if (pattern.size < 4)
        success_data({'services' => search_for_service_in_services(@services, pattern)})
      end

      def search_services_for_uri(pattern)
        return fail('no pattern provided') if pattern.nil?
        return fail('invalid pattern provided') if (pattern.size < 4)
        found = {}
        @services.each do |name, service|
          uris = @service_uris[name]
          uris ||= []
          uris.each do |uri|
            found[name] ||= []
            found[name] << uri if uri.include?(pattern)
          end
        end
        # { '1' => ["http://localhost/1"]}
        success_data('services' => found)
      end


      def search_domain_perspective(domain_perspective, pattern)
        services_list = search_for_service(pattern)['data']['services']
        found = {}
        services_list.each do |id, service|
          found[id] = service if @service_associations[id]['domain_perspectives'].include?(domain_perspective)
        end
        return success_data({'services' => found})
      end

      def service_by_name(name)
        @services[name].nil? ? success_data({'services' => {}}) : success_data({'services' => { name => @services[name]}})
      end

      def service_definition(service)
      end

      def configure_meta_for_service(service, meta)
        return fail('not authorized') if not @authorized
        return fail('no meta provided') if meta.nil?
        return fail('invalid meta') if not meta.is_a?(Hash)
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('unknown service provided') if @services[service].nil?
        return fail('failure configuring service with meta') if @broken
        @meta[service] = meta
      end

      def configure_meta_for_service_component(service_component, meta)
        return fail('not authorized') if not @authorized
        return fail('no meta provided') if meta.nil?
        return fail('invalid meta') if not meta.is_a?(Hash)
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('unknown service component provided') if (not @service_components.include?(service_component))
        return fail('failure configuring service component with meta') if @broken
        @meta[service_component] = meta
      end      

      def meta_for_service(service)
        @meta[service]
      end

      def meta_for_service_component(service_component)
        @meta[service_component]
      end

      def add_service_uri(service, uri)
        return fail('not authorized') if not @authorized
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure configuring service') if @broken
        @service_uris[service] ||= []
        @service_uris[service] << uri
        success
      end

      def service_uris(service)
        return fail('not authorized') if not @authorized
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure listing service URIs') if @broken

        @service_uris[service] ||= []
        result = {'bindings' => {}}
        @service_uris.each do |service, uri|
          result['bindings'][uri[0]] = {'access_point' => uri[0]}
        end
        success_data(result)
      end

      def remove_uri_from_service(service, uri)
        return fail('not authorized') if not @authorized
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure removing URI from service') if @broken
        @service_uris[service].delete(uri)
        success
      end

      def add_contact_to_domain_perspective(domain_perspective, contact)
        return fail('failure adding contact') if @broken        
        return fail('no domain perspective provided') if not domain_perspective
        return fail('invalid domain perspective provided') if (domain_perspective and domain_perspective.strip == "")        
        if domain_perspective and (not @domain_perspectives.include?(domain_perspective))
          return success('unknown domain perspective provided')
        end        
        return fail('no contact details provided') if not contact
        return fail('invalid contact details provided') if (not contact.is_a?(Hash)) or (contact == {})
        @contacts[domain_perspective] ||= []
        return fail('contact already exists - remove first to update') if @contacts[domain_perspective].include?(contact)
        @contacts[domain_perspective] << contact
        success
      end

      def contact_details_for_domain_perspective(domain_perspective)
        return fail('failure retrieving contact details') if @broken        
        return fail('no domain perspective provided') if not domain_perspective
        return fail('invalid domain perspective provided') if (domain_perspective and domain_perspective.strip == "")        
        if domain_perspective and (not @domain_perspectives.include?(domain_perspective))
          return success('unknown domain perspective provided')
        end        
        @contacts[domain_perspective] ||= []
        success_data({'contacts' => @contacts[domain_perspective]})
      end      

      def remove_contact_from_domain_perspective(domain_perspective, contact)
        # byebug
        return fail('failure removing contact') if @broken        
        return fail('no domain perspective provided') if not domain_perspective
        return fail('invalid domain perspective provided') if (domain_perspective and domain_perspective.strip == "")        
        if domain_perspective and (not @domain_perspectives.include?(domain_perspective))
          return success('unknown domain perspective provided')
        end        
        return fail('no contact details provided') if not contact
        return fail('invalid contact details provided') if (not contact.is_a?(Hash)) or (contact == {})
        @contacts[domain_perspective] ||= []
        return fail('unknown contact') if not @contacts[domain_perspective].include?(contact)
        @contacts[domain_perspective].delete(contact)
        success
      end

      private

      def check_dss(service)
        return true if not service['meta'].include?('dss')
        result = @dss.query(service['name'])
        return false if result.nil? or result == 'error'
        result
      end

      def does_domain_perspective_have_service_components_associated?(domain_perspective)
        count = 0
        @service_component_associations.each do |service_component, associations|
          count = count + 1 if associations['domain_perspectives'] and associations['domain_perspectives'].include?(domain_perspective)
        end
        count > 0
      end

      def does_service_component_have_services_associated?(service_component)
        return false if not @service_component_associations[service_component]
        return false if not @service_component_associations[service_component]['services']
        return @service_component_associations[service_component]['services'].count > 0
      end

      def search_for_service_in_services(list, pattern)
        matches = {}
        list.each do |id, service|
          matches[id] = service if (id.include?(pattern)) or (service['description'] and service['description'].include?(pattern)) or (service['definition'] and service['definition'].include?(pattern))
        end
        matches.each do |id, service|
          service['uris'] = {}
          @service_uris[service['name']] ||= []
          @service_uris[service['name']].each do |uri|
            service['uris'][uri] = { 'access_point' => uri }
          end
        end
        matches
      end
    end
  end
end
