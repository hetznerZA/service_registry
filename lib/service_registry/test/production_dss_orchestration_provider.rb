module ServiceRegistry
  module Test
    class ProductionDSSOrchestrationProvider < BaseDSSOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Querying a decision support system", ServiceRegistry::Test::ProductionDSSOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Querying a decision support system", ServiceRegistry::Test::ProductionDSSOrchestrationProvider)
