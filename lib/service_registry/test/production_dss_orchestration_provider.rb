require "service_registry/test/base_dss_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class ProductionDSSOrchestrationProvider < BaseDSSOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Querying a decision support system", ServiceRegistry::Test::ProductionDSSOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Querying a decision support system", ServiceRegistry::Test::ProductionDSSOrchestrationProvider)
