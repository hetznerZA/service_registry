require 'uri'

module ServiceRegistry
  module Test
    class StubServiceRegistry < ServiceRegistry::Providers::JSendProvider
      attr_reader :dss, :services, :broken, :service_component_associations
      attr_writer :authorized

      def initialize
        @authorized = true
        @meta = {}
        @services = {}
        @domain_perspectives = []
        @service_components = []
        @available = false
        @broken = false
        @service_component_associations = {}
        @service_associations = {}
      end

      def available?
        success_data('available' => @available)
      end

      def register_service(service)
        return fail('not authorized') if not @authorized
        return fail('failure registering service') if @broken
        return fail('no service identifier provided') if service.nil? or service['name'].nil?
        return fail('invalid service identifier provided') if ((not service.is_a? Hash) or (service['name'].strip == ""))
        return fail('service already exists') if not @services[service['name']].nil?
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

      def reset_service_components
        @service_components = []
      end

      def list_domain_perspectives
        return fail('failure listing domain perspectives') if @broken
        success_data({ 'domain_perspectives' => @domain_perspectives })
      end

      def list_service_components(domain_perspective = nil)
        return fail('failure retrieving service components') if @broken
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

      def register_domain_perspective(domain_perspective)
        return fail('not authorized') if not @authorized
        return fail('failure registering domain perspective') if @broken
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective') if (domain_perspective and domain_perspective.strip == "")
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

      def does_service_component_have_service_associated?(service_component, service)
        return success_data({'associated' => false}) if not @service_component_associations[service_component]
        return success_data({'associated' => false}) if not @service_component_associations[service_component]['services']
        return success_data({'associated' => @service_component_associations[service_component]['services'].include?(service)})
      end

      def deregister_domain_perspective(domain_perspective)
        return fail('not authorized') if not @authorized
        return fail('failure deregistering domain perspective') if @broken
        if not @domain_perspectives.include?(domain_perspective)
          return success('domain perspective unknown')
        end
        return fail('domain perspective has associations') if does_domain_perspective_have_service_components_associated?(domain_perspective)
        @domain_perspectives.delete(domain_perspective)
        return success('domain perspective deregistered')
      end

      def register_service_component(service_component)
        return fail('not authorized') if not @authorized
        return fail('failure registering service component') if @broken
        return fail('no service component identifier provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component and service_component.strip == "")
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
        return fail('no service identifier provided') if service.nil?
        return fail('invalid service identifier provided') if (service.strip == "")
        return success('unknown service') if @services[service].nil?
        @services.delete(service)
        success('service deregistered')
      end

      def deregister_service_component(service_component)
        return fail('not authorized') if not @authorized
        return fail('failure deregistering service component') if @broken
        return fail('no service component identifier provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component and service_component.strip == "")
        if @service_components.include?(service_component)
          return fail('service component has service associations') if does_service_component_have_services_associated?(service_component)
          return fail('service component has domain perspective associations') if does_service_component_have_domain_perspectives_associated?(service_component)
          @service_components.delete(service_component)
          return success('service component deregistered')
service component has domain perspective associations
        else
          return success('service component unknown')
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
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure associating service component with service') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['services'] ||= []
        return fail('already associated') if @service_component_associations[service_component]['services'].include?(service)
        @service_component_associations[service_component]['services'] << service
        success
      end

      def disassociate_service_component_from_service(service, service_component)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure disassociating service component with service') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['services'] ||= []
        return fail('not associated') if not @service_component_associations[service_component]['services'].include?(service)
        @service_component_associations[service_component]['services'].delete(service)
        success
      end

      def associate_service_component_with_domain_perspective(domain_perspective, service_component)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure associating service component with domain perspective') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['domain_perspectives'] ||= []
        return fail('already associated') if @service_component_associations[service_component]['domain_perspectives'].include?(domain_perspective)
        @service_component_associations[service_component]['domain_perspectives'] << domain_perspective
        success
      end

      def disassociate_service_component_from_domain_perspective(domain_perspective, service_component)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure disassociating service component from domain perspective') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['domain_perspectives'] ||= []
        return fail('not associated') if not @service_component_associations[service_component]['domain_perspectives'].include?(domain_perspective)
        @service_component_associations[service_component]['domain_perspectives'].delete(domain_perspective)
        success
      end

      def delete_all_service_components
        @service_components = []
        success
      end

      def deregister_all_services_for_service_component(service_component)
        @service_component_associations[service_component]['services'] = [] if @service_component_associations[service_component]
        success
      end

      def associate_service_with_service_component(service_component, service)
        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['services'] ||= []
        @service_component_associations[service_component]['services'] << service
        success
      end

      def configure_service_component_uri(service_component, uri)
        return fail('not authorized') if not @authorized
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        return fail('failure configuring service component') if @broken
        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['uri'] = uri
        success
      end

      def service_component_uri(service_component)
        return success_data({'uri' => nil}) if (not @service_component_associations[service_component]) or (not @service_component_associations[service_component]['uri'])
        success_data({'uri' => @service_component_associations[service_component]['uri']})
      end

      def register_service_definition(service, service_definition)
        return fail('not authorized') if not @authorized
        return fail('failure registering service definition') if @broken
        return fail('no service identifier provided') if service.nil?
        return fail('invalid service identifier provided') if service.strip == ""
        return fail('unknown service identifier provided') if @services[service].nil?
        return fail('no service definition provided') if service_definition.nil?
        return fail('invalid service definition provided') if service_definition.nil? or (not service_definition.include?("wadl"))

        @services[service]['definition'] = service_definition
        success('service definition registered')
      end

      def deregister_service_definition(service)
        return fail('not authorized') if not @authorized
        return fail('invalid service identifier provided') if service.nil? or (service.strip == "")
        return fail('unknown service identifier provided') if @services[service].nil?
        @services[service].delete('definition')
        success('service definition deregistered')
      end

      def service_registered?(service)
        success_data({'registered' => (not (@services[service].nil?))})
      end

      def service_definition_for_service(service)
        return fail('no service provided') if service.nil?
        return fail('invalid service identifier provided') if (service.strip == "")
        return fail('unknown service identifier provided') if @services[service].nil?
        return fail('service has no definition') if @services[service]['definition'].nil?
        return success_data({'definition' => @services[service]['definition']}) if (not service.nil?) and (not @services[service].nil?)
        success_data({'definition' => nil})
      end

      def search_for_service(pattern)
        return fail('invalid pattern') if pattern.nil?
        return fail('pattern too short') if (pattern.size < 4)
        success_data({'services' => search_for_service_in_services(@services, pattern)})
      end

      def search_domain_perspective(domain_perspective, pattern)
        domain_perspective_associations(domain_perspective)['data']['associations'].each do |service_component|
          @service_component_associations[service_component] ||= {}
          service_list = {}
          @service_component_associations[service_component]['services'].each do |id|
            service_list[id] = @services[id]
          end
          return success_data({'services' => search_for_service_in_services(service_list, pattern)})
        end
        return success_data({'services' => {}})
      end

      def service_by_id(id)
        @services[id].nil? ? success_data({'services' => []}) : success_data({'services' => [@services[id]]})
      end

      def service_definition(service)
      end

      def configure_meta_for_service(service, meta)
        return fail('not authorized') if not @authorized
        return fail('no meta provided') if meta.nil?
        return fail('invalid meta') if not meta.is_a?(Hash)
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure configuring service with meta') if @broken
        @meta[service] = meta
      end

      def meta_for_service(service)
        @meta[service]
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

      def service_service_component_associations(service)
        return nil if service.nil?
        associated = {}
        @service_component_associations.each do |id, service_component|
          if service_component['services'] and service_component['services'].include?(service)
            associated[id] = { 'uri' => service_component_uri(id)['data']['uri'], 'status' => '100' }
          end
        end
        associated
      end

      def search_for_service_in_services(list, pattern)
        matches = []
        list.each do |id, service|
          matches << service if (id == pattern) or (service['description'] and service['description'].include?(pattern)) or (service['definition'] and service['definition'].include?(pattern))
        end
        matches.each do |service|
          service['service_components'] = service_service_component_associations(service['name'])
        end
        matches
      end
    end
  end
end
