require "service_registry/test/base_orchestration_provider"

module ServiceRegistry
  module Test
    class BaseAssociationOrchestrationProvider < BaseOrchestrationProvider
      def given_some_or_no_associations_of_service_components_with_domain_perspective
        @domain_perspective_associations = @iut.domain_perspective_associations(@domain_perspective)
      end

      def given_some_or_no_associations_of_domain_perspectives_with_service_component
        @service_component_domain_perspective_associations = @iut.service_component_domain_perspective_associations(@service_component)
      end

      def disassociate_domain_perspective_from_service_component
        process_result(@iut.disassociate_service_component_from_domain_perspective(@domain_perspective, @service_component))
        process_result(@iut.domain_perspective_associations(@domain_perspective))
        @domain_perspective_associations = data['associations']
      end

      def disassociate_domain_perspective_from_service
        process_result(@iut.disassociate_service_from_domain_perspective(@domain_perspective, service_name))
        process_result(@iut.domain_perspective_associations(@domain_perspective))
        @domain_perspective_associations = data['associations']
      end

      def service_component_associations_changed?
        process_result(@iut.service_component_domain_perspective_associations(@service_component))
        not arrays_the_same?(data['associations'], @service_component_domain_perspective_associations)
      end

      def domain_perspective_associations_changed?
        process_result(@iut.domain_perspective_associations(@domain_perspective))
        not arrays_the_same?(data['associations'].to_a, @domain_perspective_associations.to_a)
      end

      def no_service_associations
        process_result(@iut.service_associations(service_name))
        data['associations']['domain_perspectives'].each do |id, domain_perspective|
          @iut.disassociate_service_from_domain_perspective(domain_perspective, service_name)
        end
        data['uris'].each do |id, uri|
          @iut.remove_uri_from_service(service_name, uri)
        end
      end

      def request_associations_for_service
        process_result(@iut.service_associations(service_name))
      end

      def received_an_empty_dictionary_of_service_associations
        uris = data['uris']
        domain_perspectives = data['associations']['domain_perspectives']
        (uris == {}) and (domain_perspectives == {})
      end

      def received_associations_dictionary_with_domain_perspective_associations
        data['associations']['domain_perspectives'].first[1] == @domain_perspective_1
      end

      def received_associations_dictionary_with_service_component_uris
        data['uris'].first[1] == @service_uri_1
      end
    end
  end
end
