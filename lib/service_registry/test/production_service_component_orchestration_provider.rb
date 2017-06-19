require "service_registry/test/base_service_component_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class ProductionServiceComponentOrchestrationProvider < BaseServiceComponentOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Listing service components", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Registering service components", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "De-registering a service component", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Configuring a URI for a service component", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Listing service components", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Registering service components", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "De-registering a service component", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Configuring a URI for a service component", ServiceRegistry::Test::ProductionServiceComponentOrchestrationProvider)
