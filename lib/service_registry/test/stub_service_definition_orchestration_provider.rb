module ServiceRegistry
  module Test
    class StubServiceDefinitionOrchestrationProvider < BaseServiceDefinitionOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Registering service definitions", ServiceRegistry::Test::StubServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Deregistering a service definition", ServiceRegistry::Test::StubServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Retrieve a service definition for a service", ServiceRegistry::Test::StubServiceDefinitionOrchestrationProvider)
