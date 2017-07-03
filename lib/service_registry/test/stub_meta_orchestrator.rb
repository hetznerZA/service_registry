require "service_registry/test/base_meta_orchestrator"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class StubMetaOrchestrationProvider < BaseMetaOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Configuring meta for a service", ServiceRegistry::Test::StubMetaOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Configuring meta for a service component", ServiceRegistry::Test::StubMetaOrchestrationProvider)
