require "service_registry/test/base_dss_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class StubDSSOrchestrationProvider < BaseDSSOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Querying a decision support system", ServiceRegistry::Test::StubDSSOrchestrationProvider)
