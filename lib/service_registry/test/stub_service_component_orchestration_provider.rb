module ServiceRegistry
  module Test
    class StubServiceComponentOrchestrationProvider < OrchestrationProvider
      def list_service_components
        process_result(@iut.list_service_components(@domain_perspective))
      end

      def given_service_components_exist
        process_result(@iut.delete_all_service_components)
        process_result(@iut.register_service_component(@service_component_1))
        process_result(@iut.register_service_component(@service_component_2))
      end

      def given_service_components_exist_in_the_domain_perspective
        process_result(@iut.delete_all_service_components)
        process_result(@iut.register_service_component(@service_component_1))
        process_result(@iut.register_service_component(@service_component_2))
        process_result(@iut.associate_service_component_with_domain_perspective(@domain_perspective, @service_component_1))
      end

      def given_no_service_components_exist
        process_result(@iut.delete_all_service_components)
      end

      def given_no_service_components_exist_in_domain_perspective
        process_result(@iut.delete_all_service_components)
      end

      def received_list_of_all_service_components?
        success? and data['service_components'].include?(@service_component_1) and data['service_components'].include?(@service_component_2)
      end

      def received_list_of_all_service_components_in_domain_perspective?
        success? and (data['service_components'].include?(@service_component_1)) and (data['service_components'].size == 1)
      end

      def received_empty_list_of_service_components?
        success? and (data['service_components'] == [])
      end

      def register_service_component
        process_result(@iut.register_service_component(@service_component))
      end

      def is_service_component_available?
        @iut.fix
        process_result(@iut.list_service_components)
        success? and data['service_components'].include?(@service_component)
      end

      def deregister_service_component
        process_result(@iut.deregister_service_component(@service_component))
      end

      def is_service_component_configured_with_URI?
        process_result(@iut.service_component_uri(@service_component))
        data['uri'] == @uri
      end

      def service_component_uri_changed?
        process_result(@iut.service_component_uri(@service_component))
        @uri = data['uri']
        @uri != @pre_uri
      end

      def given_no_services_associated_with_service_component
        process_result(@iut.deregister_all_services_for_service_component(@service_component))
      end

      def associate_services_with_service_component
        process_result(@iut.associate_service_with_service_component(@service_component, @service_1['id']))
        process_result(@iut.associate_service_with_service_component(@service_component, @service_2['id']))
      end

      def given_no_domain_perspectives_associated_with_service_component
        # do nothing, when the test starts none of these exist
      end
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Listing service components", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Registering service components", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "De-registering a service component", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Configuring a URI for a service component", ServiceRegistry::Test::StubServiceComponentOrchestrationProvider)
