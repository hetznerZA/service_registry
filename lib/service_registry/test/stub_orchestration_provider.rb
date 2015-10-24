module ServiceRegistry
  module Test
    class StubOrchestrationProvider
      attr_accessor :iut, :result, :domain_perspective, :service_component, :service
      attr_reader :dss_decorated_service, :secure_service, :query, :configuration_bootstrap

      def initialize
        @dss = ServiceRegistry::Test::StubDSS.new
        @iut = ServiceRegistry::Test::StubServiceRegistry.new
        @iut.associate_dss(@dss)
        @configuration_service = ServiceRegistry::Test::StubConfigurationService.new
        @dss_decorated_service = { 'id' => 'dss_decorated_service_id', 'description' => 'secure service A', 'meta' => 'dss' }
        @secure_service = { 'id' => 'secure_service', 'description' => 'secure service B' }
        @notifications = []
        @domain_perspective_associations = []
        @service_component_domain_perspective_associations = []
        @domain_perspective_1 = 'domain_perspective_1'
        @domain_perspective_2 = 'domain_perspective_2'
        @domain_perspective = nil
        @service_component = nil
        @service = nil
        @service_component_1 = 'sc1.dev.auto-h.net'
        @service_component_2 = 'sc2.dev.auto-h.net'
        @service_1 = 'service_id_1'
        @service_2 = 'service_id_2'
      end

      def given_a_service_decorated_with_dss_meta
        @service = @dss_decorated_service
        process_result(@iut.register_service(@dss_decorated_service))
      end

      def given_dss_indicates_service_inclusion
        @dss.select(@service)
      end

      def given_dss_indicates_service_exclusion
        @dss.deselect(@service)
      end

      def given_dss_error_indication
        @dss.error
      end

      def select_service
        @query = 'secure service'
      end

      def query_a_service
        process_result(@iut.query_service_by_pattern(@query))
      end

      def make_dss_unavailable
        @dss.break
      end

      def given_dss_indicates_service_not_known
        @dss.deselect(@service)
      end

      def service_included_in_results?
        (not @result.nil?) and (not @result == 'error') and (@result[@service['id']] == @service)
      end

      def given_no_configuration_service_bootstrap
        @configuration_bootstrap = {}
      end

      def given_no_identifier_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd'}
      end

      def given_invalid_identifier_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => ' '}
      end

      def given_configuration_service_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => 'identifier' }
      end

      def given_configuration_service_inaccessible
        @configuration_service.break
      end

      def given_no_configuration_in_configuration_service
        @configuration_service.clear_configuration
      end

      def given_valid_configuration_in_configuration_service
        @configuration_service.configure(@configuration_bootstrap)
      end

      def given_valid_identifier_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => 'identifier' }
        @configuration_service.configure(@configuration_bootstrap)
      end

      def initialize_service_registry
        process_result(@iut.bootstrap(@configuration_bootstrap, @configuration_service))
      end

      def has_received_notification?(message)
        @notifications.each do |notification|
          return true if notification == message
        end
        false
      end

      def service_registry_available?
        @iut.available?
      end

      def define_one_domain_perspective
        process_result(@iut.delete_all_domain_perspectives)
        process_result(@iut.register_domain_perspective(@domain_perspective_1))
      end

      def define_multiple_domain_perspectives
        process_result(@iut.delete_all_domain_perspectives)
        process_result(@iut.register_domain_perspective(@domain_perspective_1))
        process_result(@iut.register_domain_perspective(@domain_perspective_2))
      end

      def list_domain_perspectives
        process_result(@iut.list_domain_perspectives)
      end

      def list_service_components
        process_result(@iut.list_service_components)
      end

      def given_service_components_exist
        process_result(@iut.delete_all_service_components)
        process_result(@iut.register_service_component(@service_component_1))
        process_result(@iut.register_service_component(@service_component_2))
      end

      def given_no_service_components_exist
        process_result(@iut.delete_all_service_components)
      end

      def received_list_of_all_service_components?
        @result.include?(@service_component_1) and @result.include?(@service_component_2)
      end

      def received_one_domain_perspective?
        (@result.size == 1) and (@result.include?(@domain_perspective_1))
      end

      def received_no_service_components?
        (@result.size == 0) and (@result == [])
      end

      def received_multiple_domain_perspectives?
        (@result.size == 2) and (@result.include?(@domain_perspective_1)) and (@result.include?(@domain_perspective_2))
      end

      def received_no_domain_perspectives?
        (@result.size == 0) and (@result == [])
      end

      def clear_all_domain_perspectives
        @iut.delete_all_domain_perspectives
      end

      def break_registry
        @iut.break
      end

      def given_no_domain_perspective
        @domain_perspective = nil
      end

      def given_no_service
        @service = nil
      end

      def register_domain_perspective
        process_result(@iut.register_domain_perspective(@domain_perspective))
      end

      def register_service_component
        process_result(@iut.register_service_component(@service_component))
      end

      def is_domain_perspective_available?
        @iut.fix
        available = @iut.list_domain_perspectives
        available.include?(@domain_perspective)
      end

      def is_service_component_available?
        @iut.fix
        available = @iut.list_service_components
        available.include?(@service_component)
      end

      def given_a_new_domain_perspective
        @iut.delete_all_domain_perspectives
        @domain_perspective = @domain_perspective_1
      end

      def given_an_existing_domain_perspective
        define_one_domain_perspective
        @domain_perspective = @domain_perspective_1
      end

      def given_existing_service_component_identifier
        @iut.register_service_component(@service_component_1)
        @service_component = @service_component_1
      end

      def given_an_invalid_domain_perspective
        @domain_perspective = " "
      end

      def given_invalid_service_component_identifier
        @service_component = " "
      end

      def given_invalid_service
        @service = " "
      end

      def given_no_service_component_identifier
        @service_component = nil
      end

      def given_unknown_domain_perspective
        @domain_perspective = 'unknown'
      end

      def deregister_domain_perspective
        process_result(@iut.deregister_domain_perspective(@domain_perspective))
      end

      def given_no_service_components_associated_with_domain_perspective
        @iut.delete_domain_perspective_service_component_associations(@domain_perspective)
      end

      def given_service_components_associated_with_domain_perspective
        @iut.associate_service_component_with_domain_perspective(@domain_perspective, @service_component_1)
      end

      def given_new_service_component_identifier
        @service_component = @service_component_1
      end

      def given_unknown_service_component
        @service_component = 'unknown'
      end

      def deregister_service_component
        process_result(@iut.deregister_service_component(@service_component))
      end

      def given_no_services_associated_with_service_component
        process_result(@iut.deregister_all_services_for_service_component(@service_component))
      end

      def given_some_or_no_associations_of_service_components_with_domain_perspective
        @domain_perspective_associations = @iut.domain_perspective_associations(@domain_perspective)
      end

      def given_some_or_no_associations_of_domain_perspectives_with_service_component
        @service_component_domain_perspective_associations = @iut.service_component_domain_perspective_associations(@service_component)
      end

      def service_component_associations_changed?
        not arrays_the_same?(@iut.service_component_domain_perspective_associations(@service_component), @service_component_domain_perspective_associations)
      end

      def arrays_the_same?(a, b)
        c = a - b
        d = b - a
        (c.empty? and d.empty?)
      end

      def domain_perspective_associations_changed?
        not arrays_the_same?(@iut.domain_perspective_associations(@domain_perspective), @domain_perspective_associations)
      end

      def service_associations_changed?
        not arrays_the_same?(@iut.service_associations(@service), @service_associations)
      end

      def associate_services_with_service_component
        process_result(@iut.associate_service_with_service_component(@service_component, @service_1))
        process_result(@iut.associate_service_with_service_component(@service_component, @service_2))
      end

      def associate_domain_perspective_with_service_component
        result = process_result(@iut.associate_service_component_with_domain_perspective(@domain_perspective, @service_component))
        @domain_perspective_associations = @iut.domain_perspective_associations(@domain_perspective)
        result
      end

      def is_service_component_associated_with_domain_perspective?
        @iut.service_component_domain_perspective_associations(@service_component).include?(@domain_perspective)
      end

      def is_service_component_associated_with_service?
        @iut.service_component_service_associations(@service_component).include?(@service)
      end

      def associate_service_with_service_component
        process_result(@iut.associate_service_component_with_service(@service, @service_component))
      end

      def given_a_valid_service
        @service = @service_1
      end

      def process_result(result)
        @result = result
        
        @notifications << @result['notifications'] if @result and result.is_a?(Hash) and @result['notifications']
        @notifications.flatten!
      end
    end
  end
end
