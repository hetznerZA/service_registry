module ServiceRegistry
  module Test
    class ProductionContactsOrchestrationProvider < ContactsOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Add a contact for a domain perspectives", ServiceRegistry::Test::ProductionContactsOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Find contacts for domain perspectives", ServiceRegistry::Test::ProductionContactsOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("tfa", "Removing a contact for a domain perspectives", ServiceRegistry::Test::ProductionContactsOrchestrationProvider)

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Add a contact for a domain perspectives", ServiceRegistry::Test::ProductionContactsOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Find contacts for domain perspectives", ServiceRegistry::Test::ProductionContactsOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("production", "Removing a contact for a domain perspectives", ServiceRegistry::Test::ProductionContactsOrchestrationProvider)
