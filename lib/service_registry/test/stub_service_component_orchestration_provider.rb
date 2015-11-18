module ServiceRegistry
  module Test
    class StubServiceComponentOrchestrationProvider < BaseServiceComponentOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Listing service components", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Registering service components", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "De-registering a service component", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Configuring a URI for a service component", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
