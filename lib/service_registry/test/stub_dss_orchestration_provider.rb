module ServiceRegistry
  module Test
    class StubDSSOrchestrationProvider < BaseDSSOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Querying a decision support system", ServiceRegistry::Test::StubDSSOrchestrationProvider)
