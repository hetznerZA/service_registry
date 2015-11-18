module ServiceRegistry
  module Test
    class ProductionMetaOrchestrationProvider < BaseMetaOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Configuring meta for a service", ServiceRegistry::Test::ProductionMetaOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Configuring meta for a service", ServiceRegistry::Test::ProductionMetaOrchestrationProvider)
