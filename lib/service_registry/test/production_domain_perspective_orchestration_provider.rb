require "service_registry/test/base_domain_perspective_orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry
  module Test
    class ProductionDomainPerspectiveOrchestrationProvider < BaseDomainPerspectiveOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Deregistering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Listing domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Registering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Teams are domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Deregistering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Listing domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Registering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Teams are domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
