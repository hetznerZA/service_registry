module ServiceRegistry
  module Test
    class StubContactsOrchestrationProvider < ContactsOrchestrationProvider
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Add a contact for a domain perspectives", ServiceRegistry::Test::StubContactsOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Find contacts for domain perspectives", ServiceRegistry::Test::StubContactsOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Removing a contact for a domain perspectives", ServiceRegistry::Test::StubContactsOrchestrationProvider)
