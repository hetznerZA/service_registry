module ServiceRegistry
  module Test
    class ProductionBootstrapOrchestrationProvider < ProductionOrchestrationProvider
      def given_no_configuration_service_bootstrap
#        @configuration_bootstrap = {}
      end

      def given_invalid_configuration_service_bootstrap
#        @configuration_bootstrap = nil
      end

      def given_no_identifier_bootstrap
#        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd'}
      end

      def given_invalid_identifier_bootstrap
#        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => ' '}
      end

      def given_configuration_service_bootstrap
#        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => 'identifier' }
      end

      def given_configuration_service_inaccessible
#        @configuration_service.break
      end

      def given_no_configuration_in_configuration_service
#        @configuration_service.clear_configuration
      end

      def given_invalid_configuration_in_configuration_service
#        @configuration_service.clear_configuration
#        @configuration_service.configure({})
      end

      def given_valid_configuration_in_configuration_service
#        @configuration_service.configure(@configuration_bootstrap)
      end

      def given_valid_identifier_bootstrap
#        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => 'identifier' }
#        @configuration_service.configure(@configuration_bootstrap)
      end

      def initialize_service_registry
#        process_result(@iut.bootstrap(@configuration_bootstrap, @configuration_service))
      end

      def service_registry_available?
#        process_result(@iut.available?)
#        success? and (data['available'] == true)
      end
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Bootstrap with configuration service", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Bootstrap with identifier", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Bootstrap with configuration service", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Bootstrap with identifier", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)
