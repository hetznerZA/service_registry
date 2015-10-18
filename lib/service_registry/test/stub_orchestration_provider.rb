module ServiceRegistry
  module Test
    class StubOrchestrationProvider
      attr_accessor :iut, :result
      attr_reader :dss_decorated_service, :secure_service, :service, :query, :configuration_bootstrap

      def initialize
        @dss = ServiceRegistry::Test::StubDSS.new
        @iut = ServiceRegistry::Test::StubServiceRegistry.new
        @iut.associate_dss(@dss)
        @configuration_service = ServiceRegistry::Test::StubConfigurationService.new
        @dss_decorated_service = { 'id' => 'dss_decorated_service_id', 'description' => 'secure service A', 'meta' => 'dss' }
        @secure_service = { 'id' => 'secure_service', 'description' => 'secure service B' }
        @notifications = []
      end

      def given_a_service_decorated_with_dss_meta
        @service = @dss_decorated_service
        @iut.register_service(@dss_decorated_service)
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
        @result = @iut.query_service_by_pattern(@query)
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
        result = @iut.bootstrap(@configuration_bootstrap, @configuration_service)
        @notifications << result['notifications'] if result and result['notifications']
        @notifications.flatten!
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
    end
  end
end
