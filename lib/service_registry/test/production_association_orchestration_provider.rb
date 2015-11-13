module ServiceRegistry
  module Test
    class ProductionAssociationOrchestrationProvider < BaseAssociationOrchestrationProvider
      def is_service_component_associated_with_domain_perspective?
      	associations = @iut.domain_perspective_associations(@domain_perspective)['data']['associations']['service_components']
      	found = false
      	associations.each do |id, associated|
      	  found = true if (id.include?(@service_component) and associated)
      	end
      	found
      end
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
