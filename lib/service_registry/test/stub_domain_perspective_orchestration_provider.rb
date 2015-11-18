module ServiceRegistry
  module Test
    class StubDomainPerspectiveOrchestrationProvider < BaseDomainPerspectiveOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Deregistering domain perspectives", ServiceRegistry::Test::StubDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Listing domain perspectives", ServiceRegistry::Test::StubDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Registering domain perspectives", ServiceRegistry::Test::StubDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Teams are domain perspectives", ServiceRegistry::Test::StubDomainPerspectiveOrchestrationProvider)
