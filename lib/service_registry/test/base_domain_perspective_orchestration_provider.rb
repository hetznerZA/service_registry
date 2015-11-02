module ServiceRegistry
  module Test
    class BaseDomainPerspectiveOrchestrationProvider < BaseOrchestrationProvider
      def given_no_service_components_associated_with_domain_perspective
        @iut.delete_domain_perspective_service_component_associations(@domain_perspective)
      end

      def given_service_components_associated_with_domain_perspective
        @iut.associate_service_component_with_domain_perspective(@domain_perspective, @service_component_1)
      end

      def clear_all_domain_perspectives
        @iut.delete_all_domain_perspectives
      end

      def list_domain_perspectives
        process_result(@iut.list_domain_perspectives)
      end

      def register_domain_perspective
        process_result(@iut.register_domain_perspective(@domain_perspective))
      end

      def deregister_domain_perspective
        process_result(@iut.deregister_domain_perspective(@domain_perspective))
      end

      def define_one_domain_perspective
        process_result(@iut.delete_all_domain_perspectives)
        process_result(@iut.register_domain_perspective(@domain_perspective_1))
      end

      def define_multiple_domain_perspectives
        process_result(@iut.delete_all_domain_perspectives)
        process_result(@iut.register_domain_perspective(@domain_perspective_1))
        process_result(@iut.register_domain_perspective(@domain_perspective_2))
      end

      def is_domain_perspective_available?
        @iut.fix
        process_result(@iut.list_domain_perspectives)
        success? and data['domain_perspectives'].include?(@domain_perspective)
      end

      def received_one_domain_perspective?
        success? and (data['domain_perspectives'].size == 1) and (data['domain_perspectives'].include?(@domain_perspective_1))
      end

      def received_multiple_domain_perspectives?
        success? and (data['domain_perspectives'].size == 2) and (data['domain_perspectives'].include?(@domain_perspective_1)) and (data['domain_perspectives'].include?(@domain_perspective_2))
      end

      def received_an_empty_list_of_domain_perspectives?
        success? and (data['domain_perspectives'] == [])
      end
    end
  end
end
