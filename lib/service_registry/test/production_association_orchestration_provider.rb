module ServiceRegistry
  module Test
    class ProductionAssociationOrchestrationProvider < BaseAssociationOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Associate a service component with a domain perspective", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Removing service component associations from domain perspectives", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Associate a service component with a service", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Removing service component associations from services", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Associate a service component with a domain perspective", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Removing service component associations from domain perspectives", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Associate a service component with a service", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Removing service component associations from services", ServiceRegistry::Test::ProductionAssociationOrchestrationProvider)
