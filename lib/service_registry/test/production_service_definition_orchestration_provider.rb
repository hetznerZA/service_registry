require "service_registry/test/base_service_definition_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class ProductionServiceDefinitionOrchestrationProvider < BaseServiceDefinitionOrchestrationProvider
      def no_service_definition_associated
    	@iut.deregister_service_definition(service_name)
      end
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Registering service definitions", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Deregistering a service definition", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Retrieve a service definition for a service", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Registering service definitions", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Deregistering a service definition", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Retrieve a service definition for a service", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
