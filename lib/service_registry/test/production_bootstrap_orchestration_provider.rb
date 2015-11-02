module ServiceRegistry
  module Test
    class ProductionBootstrapOrchestrationProvider < BaseBootstrapOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Bootstrap with configuration service", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Bootstrap with identifier", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Bootstrap with configuration service", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Bootstrap with identifier", ServiceRegistry::Test::ProductionBootstrapOrchestrationProvider)
