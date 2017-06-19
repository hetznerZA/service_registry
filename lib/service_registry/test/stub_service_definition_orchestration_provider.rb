require "service_registry/test/base_service_definition_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class StubServiceDefinitionOrchestrationProvider < BaseServiceDefinitionOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Registering service definitions", ServiceRegistry::Test::StubServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Deregistering a service definition", ServiceRegistry::Test::StubServiceDefinitionOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Retrieve a service definition for a service", ServiceRegistry::Test::StubServiceDefinitionOrchestrationProvider)
