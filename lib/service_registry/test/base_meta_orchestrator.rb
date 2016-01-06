module ServiceRegistry
  module Test
    class BaseMetaOrchestrationProvider < BaseOrchestrationProvider
      def given_valid_meta
        @meta = @valid_meta
      end 

      def given_invalid_meta
        @meta = "invalid"
      end

      def given_no_meta
        @meta = nil
      end

      def service_has_meta_configured
        @pre_meta = @original_meta
        process_result(@iut.configure_meta_for_service(@service['name'], @original_meta))
      end

      def configure_service_meta
        s = nil if @service.nil?
        s = @service['name'] if @service.is_a?(Hash)
        s = @service if not @service.nil? and (not @service.is_a?(Hash))
        process_result(@iut.configure_meta_for_service(s, @meta))
      end

      def configure_service_component_meta
        s = nil if @service_component.nil?
        s = @service_component['name'] if @service_component.is_a?(Hash)
        s = @service_component if not @service_component.nil? and (not @service_component.is_a?(Hash))
        process_result(@iut.configure_meta_for_service_component(s, @meta))
      end

      def meta_configured?
        @iut.meta_for_service(@service['name']) == @meta
      end

      def meta_unchanged?
        @iut.meta_for_service(@service['name']) == @pre_meta
      end

      def service_component_has_meta_configured
        @pre_meta = @original_meta
        process_result(@iut.configure_meta_for_service_component(@service_component, @original_meta))
      end

      def service_component_meta_configured?
        @iut.meta_for_service_component(@service_component) == @meta
      end

      def service_component_meta_unchanged?
        @iut.meta_for_service_component(@service_component) == @pre_meta
      end

    end
  end
end
