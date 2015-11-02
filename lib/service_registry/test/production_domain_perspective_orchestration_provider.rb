module ServiceRegistry
  module Test
    class ProductionDomainPerspectiveOrchestrationProvider < BaseDomainPerspectiveOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Deregistering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Listing domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Registering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Deregistering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Listing domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Registering domain perspectives", ServiceRegistry::Test::ProductionDomainPerspectiveOrchestrationProvider)
