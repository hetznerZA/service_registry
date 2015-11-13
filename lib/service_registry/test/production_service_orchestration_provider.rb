module ServiceRegistry
  module Test
    class ProductionServiceOrchestrationProvider < BaseServiceOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "De-registering a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Registering services", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Searching for a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Map service components to services", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "De-registering a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Registering services", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Searching for a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Map service components to services", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
