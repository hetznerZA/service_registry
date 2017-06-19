require "service_registry/test/base_service_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

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
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Configuring URI for a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Listing endpoints for a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Removing URI from a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Standardizing names", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "finding services and their URIs for services that has the specified pattern in their URIs", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "De-registering a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Registering services", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Searching for a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Map service components to services", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Configuring URI for a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Listing endpoints for a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Removing URI from a service", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Standardizing names", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "finding services and their URIs for services that has the specified pattern in their URIs", ServiceRegistry::Test::ProductionServiceOrchestrationProvider)
