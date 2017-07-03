require "service_registry/test/base_meta_orchestrator"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class ProductionMetaOrchestrationProvider < BaseMetaOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Configuring meta for a service", ServiceRegistry::Test::ProductionMetaOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Configuring meta for a service", ServiceRegistry::Test::ProductionMetaOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Configuring meta for a service component", ServiceRegistry::Test::ProductionMetaOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Configuring meta for a service component", ServiceRegistry::Test::ProductionMetaOrchestrationProvider)
