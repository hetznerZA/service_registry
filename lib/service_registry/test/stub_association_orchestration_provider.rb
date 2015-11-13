module ServiceRegistry
  module Test
    class StubAssociationOrchestrationProvider < BaseAssociationOrchestrationProvider
      def is_service_component_associated_with_domain_perspective?
        process_result(@iut.service_component_domain_perspective_associations(@service_component))
        data['associations'].include?(@domain_perspective)
      end
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Associate a service component with a domain perspective", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Removing service component associations from domain perspectives", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Associate a service component with a service", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Removing service component associations from services", ServiceRegistry::Test::StubAssociationOrchestrationProvider)
