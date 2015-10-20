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
      end

      def bootstrap(configuration, configuration_service)
        @configuration = configuration
        return { 'result' => 'error', 'notifications' => ['invalid configuration service'] } if @configuration.nil?
        return { 'result' => 'error', 'notifications' => ['no configuration service'] } if @configuration['CFGSRV_PROVIDER_ADDRESS'].nil?
        return { 'result' => 'error', 'notifications' => ['no identifier'] } if @configuration['CFGSRV_IDENTIFIER'].nil?
        return { 'result' => 'error', 'notifications' => ['invalid identifier'] } if @configuration['CFGSRV_IDENTIFIER'].strip == ""
        return { 'result' => 'error', 'notifications' => ['configuration error'] } if configuration_service.broken?
        return { 'result' => 'error', 'notifications' => ['invalid configuration'] } if configuration_service.configuration.nil?
        @available = true
        return { 'result' => 'success', 'notifications' => ['configuration valid', 'valid identifier'] } if @configuration
      end

      def available?
        @available
      end

      def register_service(service)
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
        return { 'result' => 'error', 'notifications' => ['request failure'] } if @broken
        @domain_perspectives
      end

      def list_service_components
        return { 'result' => 'error', 'notifications' => ['failure retrieving service components'] } if @broken
        @service_components
      end

      def break
        @broken = true
      end

      def fix
        @broken = false
      end

      def register_domain_perspective(domain_perspective)
        return { 'result' => 'error', 'notifications' => ['failure registering domain perspective'] } if @broken
        return { 'result' => 'error', 'notifications' => ['no domain perspective provided'] } if domain_perspective.nil?
        return { 'result' => 'error', 'notifications' => ['invalid domain perspective'] } if (domain_perspective and domain_perspective.strip == "")
        if not @domain_perspectives.include?(domain_perspective)
          @domain_perspectives << domain_perspective
          return { 'result' => 'success', 'notifications' => ['domain perspective registered'] }
        else
          return { 'result' => 'success', 'notifications' => ['domain perspective already exists'] }
        end
      end

      def does_domain_perspective_have_service_components_associated?(domain_perspective)
        count = 0
        @service_component_associations.each do |service_component, associations|
          count = count + 1 if associations['domain_perspectives'] and associations['domain_perspectives'].include?(domain_perspective)
        end
        count > 0
      end

      def deregister_domain_perspective(domain_perspective)
        return { 'result' => 'error', 'notifications' => ['failure deregistering domain perspective'] } if @broken
        if not @domain_perspectives.include?(domain_perspective)
          return { 'result' => 'success', 'notifications' => ['domain perspective unknown'] }
        end
        return { 'result' => 'error', 'notifications' => ['domain perspective has associations'] } if does_domain_perspective_have_service_components_associated?(domain_perspective)
        @domain_perspectives.delete(domain_perspective)
        return { 'result' => 'success', 'notifications' => ['domain perspective deregistered'] }
      end

      def register_service_component(service_component)
        return { 'result' => 'error', 'notifications' => ['failure registering service component'] } if @broken
        return { 'result' => 'error', 'notifications' => ['no service component identifier provided'] } if service_component.nil?
        return { 'result' => 'error', 'notifications' => ['invalid service component identifier'] } if (service_component and service_component.strip == "")
        if not @service_components.include?(service_component)
          @service_components << service_component
          return { 'result' => 'success', 'notifications' => ['service component registered'] }
        else
          return { 'result' => 'success', 'notifications' => ['service component already exists'] }
        end
      end

      def deregister_service_component(service_component)
#        return { 'result' => 'error', 'notifications' => ['failure deregistering service component'] } if @broken
#        return { 'result' => 'error', 'notifications' => ['no service component identifier provided'] } if service_component.nil?
#        return { 'result' => 'error', 'notifications' => ['invalid service component identifier'] } if (service_component and service_component.strip == "")
        if @service_components.include?(service_component)
#          @service_components.delete(service_component)
#          return { 'result' => 'success', 'notifications' => ['service component deregistered'] }
        else
          return { 'result' => 'success', 'notifications' => ['service component unknown'] }
        end
      end

      def delete_domain_perspective_service_component_associations(domain_perspective)
        @service_component_associations.each do |service_component, associations|
          associations['domain_perspectives'].delete(domain_perspective) if associations['domain_perspectives'] and associations['domain_perspectives'].include(domain_perspective)
        end
      end

      def associate_service_component_with_domain_perspective(domain_perspective, service_component)
        @service_component_associations[service_component] ||= {}
        @service_component_associations[service_component]['domain_perspectives'] ||= []
        @service_component_associations[service_component]['domain_perspectives'] << domain_perspective
      end

      def delete_all_service_components
        @service_components = []
      end

      def deregister_all_services_for_service_component(service_component)
      end

      private

      def check_dss(service)
        return true if not service['meta'].include?('dss')
        result = @dss.query(service['id'])
        return false if result.nil? or result == 'error'
        result
      end
    end
  end
end
