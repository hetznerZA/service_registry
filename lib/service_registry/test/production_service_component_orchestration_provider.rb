module ServiceRegistry
  module Test
    class ProductionServiceDefinitionOrchestrationProvider < BaseServiceDefinitionOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Registering service definitions", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Deregistering a service definition", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Retrieve a service definition for a service", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Registering service definitions", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Deregistering a service definition", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Retrieve a service definition for a service", ServiceRegistry::Test::ProductionServiceDefinitionOrchestrationProvider)
