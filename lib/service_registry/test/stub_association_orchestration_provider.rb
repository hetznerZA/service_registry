module ServiceRegistry
  module Test
    class StubAssociationOrchestrationProvider < BaseAssociationOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Associate a service component with a domain perspective", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Removing service component associations from domain perspectives", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Associate a service component with a service", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Removing service component associations from services", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
