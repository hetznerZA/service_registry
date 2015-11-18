module ServiceRegistry
  module Test
    class StubServiceOrchestrationProvider < BaseServiceOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "De-registering a service", ServiceRegistry::Test::StubServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Registering services", ServiceRegistry::Test::StubServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Searching for a service", ServiceRegistry::Test::StubServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Map service components to services", ServiceRegistry::Test::StubServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Configuring URI for a service", ServiceRegistry::Test::StubServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Listing endpoints for a service", ServiceRegistry::Test::StubServiceOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Removing URI from a service", ServiceRegistry::Test::StubServiceOrchestrationProvider)