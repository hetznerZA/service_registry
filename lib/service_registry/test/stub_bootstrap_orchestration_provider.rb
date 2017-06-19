require "service_registry/test/base_bootstrap_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class StubBootstrapOrchestrationProvider < BaseBootstrapOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Bootstrap with configuration service", ServiceRegistry::Test::StubBootstrapOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Bootstrap with identifier", ServiceRegistry::Test::StubBootstrapOrchestrationProvider)
