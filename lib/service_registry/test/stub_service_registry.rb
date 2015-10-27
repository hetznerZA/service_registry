require 'uri'

module ServiceRegistry
  module Test
    class StubServiceRegistry
      attr_reader :dss, :services, :configuration, :available, :broken, :service_component_associations

      def initialize
        @services = {}
        @domain_perspectives = []
        @service_components = []
        @available = false
        @broken = false
        @service_component_associations = {}
        @service_associations = {}
      end

      def bootstrap(configuration, configuration_service)
        @configuration = configuration
        return fail('invalid configuration service') if @configuration.nil?
        return fail('no configuration service') if @configuration['CFGSRV_PROVIDER_ADDRESS'].nil?
        return fail('no identifier') if @configuration['CFGSRV_IDENTIFIER'].nil?
        return fail('invalid identifier') if @configuration['CFGSRV_IDENTIFIER'].strip == ""
        return fail('configuration error') if configuration_service.broken?
        return fail('invalid configuration') if configuration_service.configuration.nil?
        @available = true
        return success(['configuration valid', 'valid identifier']) if @configuration
      end

      def available?
        @available
      end

      def register_service(service)
         fail('no service identifier provided') if service.nil? or service['id'].nil?
         fail('invalid service identifier') if (not service.is_a? Hash)
        @services[service['id']] = service
      end

      def associate_dss(dss)
        @dss = dss
      end

      def query_service_by_pattern(pattern)
        result = {}
        @services.each do |key, service|
          result[service['id']] = service if service['description'].include?(pattern) and check_dss(service)
        end
        result
      end

      def delete_all_domain_perspectives
        @domain_perspectives = []
      end

      def list_domain_perspectives
        return fail('request failure') if @broken
        @domain_perspectives
      end

      def list_service_components
        return fail('failure retrieving service components') if @broken
        @service_components
      end

      def break
        @broken = true
      end

      def fix
        @broken = false
      end

      def register_domain_perspective(domain_perspective)
        return fail('failure registering domain perspective') if @broken
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective') if (domain_perspective and domain_perspective.strip == "")
        if not @domain_perspectives.include?(domain_perspective)
          @domain_perspectives << domain_perspective
          return fail('domain perspective registered')
        else
          return fail('domain perspective already exists')
        end
      end

      def does_domain_perspective_have_service_components_associated?(domain_perspective)
        count = 0
        @service_component_associations.each do |service_component, associations|
          count = count + 1 if associations['domain_perspectives'] and associations['domain_perspectives'].include?(domain_perspective)
        end
        count > 0
      end

      def domain_perspective_associations(domain_perspective)
        associated = []
        @service_component_associations.each do |service_component, associations|
          associated << service_component if associations['domain_perspectives'] and associations['domain_perspectives'].include?(domain_perspective)
        end
        associated
      end

      def does_service_component_have_domain_perspectives_associated?(service_component)
        return false if not @service_component_associations[service_component]
        return false if not @service_component_associations[service_component]['domain_perspectives']
        @service_component_associations[service_component]['domain_perspectives'].count > 0
      end

      def service_component_domain_perspective_associations(service_component)
        return @service_component_associations[service_component]['domain_perspectives'] if @service_component_associations[service_component] and @service_component_associations[service_component]['domain_perspectives']
        []
      end

      def does_service_component_have_services_associated?(service_component)
        return false if not @service_component_associations[service_component]
        return false if not @service_component_associations[service_component]['services']
        @service_component_associations[service_component]['services'].count > 0
      end

      def does_service_component_have_service_associated?(service_component, service)
        return false if not @service_component_associations[service_component]
        return false if not @service_component_associations[service_component]['services']
        @service_component_associations[service_component]['services'].include?(service)
      end

      def service_service_component_associations(service)
        return nil if service.nil?
        associated = {}
        @service_component_associations.each do |id, service_component|
          if service_component['services'] and service_component['services'].include?(service)
            associated[id] = { 'uri' => service_component_uri(id), 'status' => '100' }
          end
        end
        associated
      end

      def deregister_domain_perspective(domain_perspective)
        return fail('failure deregistering domain perspective') if @broken
        if not @domain_perspectives.include?(domain_perspective)
          return success('domain perspective unknown')
        end
        return fail('domain perspective has associations') if does_domain_perspective_have_service_components_associated?(domain_perspective)
        @domain_perspectives.delete(domain_perspective)
        return success('domain perspective deregistered')
      end

      def register_service_component(service_component)
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

      def deregister_service_component(service_component)
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
      end

      def associate_service_component_with_service(service, service_component)
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure associating service component with service') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['services'] ||= []
        return fail('already associated') if @service_component_associations[service_component]['services'].include?(service)
        @service_component_associations[service_component]['services'] << service
        success('success')
      end

      def disassociate_service_component_from_service(service, service_component)
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('failure disassociating service component with service') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['services'] ||= []
        return fail('not associated') if not @service_component_associations[service_component]['services'].include?(service)
        @service_component_associations[service_component]['services'].delete(service)
        success('success')
      end

      def associate_service_component_with_domain_perspective(domain_perspective, service_component)
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure associating service component with domain perspective') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['domain_perspectives'] ||= []
        return fail('already associated') if @service_component_associations[service_component]['domain_perspectives'].include?(domain_perspective)
        @service_component_associations[service_component]['domain_perspectives'] << domain_perspective
        success('success')
      end

      def disassociate_service_component_from_domain_perspective(domain_perspective, service_component)
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")
        return fail('failure disassociating service component from domain perspective') if @broken

        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['domain_perspectives'] ||= []
        return fail('not associated') if not @service_component_associations[service_component]['domain_perspectives'].include?(domain_perspective)
        @service_component_associations[service_component]['domain_perspectives'].delete(domain_perspective)
        success('success')
      end

      def delete_all_service_components
        @service_components = []
      end

      def deregister_all_services_for_service_component(service_component)
        @service_component_associations[service_component]['services'] = [] if @service_component_associations[service_component]
      end

      def associate_service_with_service_component(service_component, service)
        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['services'] ||= []
        @service_component_associations[service_component]['services'] << service
      end

      def configure_service_component_uri(service_component, uri)
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component identifier') if (service_component.strip == "")
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        return fail('failure configuring service component') if @broken
        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['uri'] = uri
      end

      def service_component_uri(service_component)
        return nil if (not @service_component_associations[service_component]) or (not @service_component_associations[service_component]['uri'])
        @service_component_associations[service_component]['uri']
      end

      def register_service_definition(service, service_definition)
        return fail('no service identifier provided') if service.nil?
        return fail('invalid service identifier') if service.strip == ""
        return fail('unknown service identifier') if @services[service].nil?
        return fail('invalid service definition') if service_definition.nil? or (not service_definition.include?("wadl"))

        @services[service]['definition'] = service_definition
        success('success')
      end

      def deregister_service_definition(service)
        return fail('invalid service identifier') if service.nil? or (service.strip == "")
        return fail('unknown service identifier') if @services[service].nil?
        @services[service].delete('definition')
        success('success')
      end

      def service_registered?(service)
        not (@services[service].nil?)
      end

      def service_definition_for_service(service)
        return fail('no service provided') if service.nil?
        return fail('invalid service identifier') if (service.strip == "")
        return fail('unknown service identifier') if @services[service].nil?
        return fail('service has no definition') if @services[service]['definition'].nil?
        return @services[service]['definition'] if (not service.nil?) and (not @services[service].nil?)
        nil
      end

      def search_for_service_in_services(list, pattern)
        matches = []
        list.each do |id, service|
          matches << service if (id == pattern) or (service['description'] and service['description'].include?(pattern)) or (service['definition'] and service['definition'].include?(pattern))
        end
        matches.each do |service|
          service['service_components'] = service_service_component_associations(service['id'])
        end
        matches
      end

      def search_for_service(pattern)
        return fail('invalid pattern') if pattern.nil?
        return fail('pattern too short') if (pattern.size < 4)
        search_for_service_in_services(@services, pattern)
      end

      def search_domain_perspective(domain_perspective, pattern)
        domain_perspective_associations(domain_perspective).each do |service_component|
          @service_component_associations[service_component] ||= {}
          service_list = {}
          @service_component_associations[service_component]['services'].each do |id|
            service_list[id] = @services[id]
          end
          return search_for_service_in_services(service_list, pattern)
        end
        return {}
      end

      def service_by_id(id)
        @services[id].nil? ? [] : [@services[id]]
      end

      def service_definition(service)
      end

      private

      def fail(message)
        { 'status' => 'fail', 'data' => { 'notifications' => message.is_a?(Array) ? message : [ message ] } }
      end

      def success(message)
        { 'status' => 'success', 'data' => { 'notifications' => message.is_a?(Array) ? message : [ message ] } }
      end

      def check_dss(service)
        return true if not service['meta'].include?('dss')
        result = @dss.query(service['id'])
        return false if result.nil? or result == 'error'
        result
      end
    end
  end
end
