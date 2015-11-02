module ServiceRegistry
  module Test
    class StubMetaOrchestrationProvider < StubOrchestrationProvider
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
        process_result(@iut.configure_meta_for_service(@service['id'], @original_meta))
      end

      def configure_service_meta
        s = nil if @service.nil?
        s = @service['id'] if @service.is_a?(Hash)
        s = @service if not @service.nil? and (not @service.is_a?(Hash))
        process_result(@iut.configure_meta_for_service(s, @meta))
      end

      def meta_configured?
        @iut.meta_for_service(@service['id']) == @meta
      end

      def meta_unchanged?
        @iut.meta_for_service(@service['id']) == @pre_meta
      end
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "Configuring meta for a service", ServiceRegistry::Test::StubMetaOrchestrationProvider)
