require_relative 'production_orchestration_provider.rb'

module ServiceRegistry
  module Test
    class ProductionAssociationOrchestrationProvider < ProductionOrchestrationProvider
      def given_some_or_no_associations_of_service_components_with_domain_perspective
#        @domain_perspective_associations = @iut.domain_perspective_associations(@domain_perspective)
      end

      def given_some_or_no_associations_of_domain_perspectives_with_service_component
#        @service_component_domain_perspective_associations = @iut.service_component_domain_perspective_associations(@service_component)
      end

      def disassociate_domain_perspective_from_service_component
#        process_result(@iut.disassociate_service_component_from_domain_perspective(@domain_perspective, @service_component))
#        process_result(@iut.domain_perspective_associations(@domain_perspective))
#        @domain_perspective_associations = data['associations']
      end

      def disassociate_service_from_service_component
#        process_result(@iut.disassociate_service_component_from_service(@service, @service_component))
      end

      def service_component_associations_changed?
#        process_result(@iut.service_component_domain_perspective_associations(@service_component))
#        not arrays_the_same?(data['associations'], @service_component_domain_perspective_associations)
      end

      def domain_perspective_associations_changed?
#        process_result(@iut.domain_perspective_associations(@domain_perspective))
#        not arrays_the_same?(data['associations'], @domain_perspective_associations)
      end

      def is_service_component_associated_with_domain_perspective?
#        process_result(@iut.service_component_domain_perspective_associations(@service_component))
#        data['associations'].include?(@domain_perspective)
      end

      def is_service_component_associated_with_service?
#        process_result(@iut.does_service_component_have_service_associated?(@service_component, @service))
#        data['associated']
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
