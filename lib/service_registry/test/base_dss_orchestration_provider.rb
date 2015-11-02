module ServiceRegistry
  module Test
    class BaseDSSOrchestrationProvider < BaseOrchestrationProvider
      alias :parent_setup :setup

      attr_reader :dss_decorated_service

      def setup
        parent_setup()

        @dss = ServiceRegistry::Test::StubDSS.new
        @iut.associate_dss(@dss)
        @dss_decorated_service = { 'id' => 'dss_decorated_service_id', 'description' => 'secure service A', 'meta' => 'dss', 'definition' => nil }
      end

      def given_a_service_decorated_with_dss_meta
        @service = @dss_decorated_service
        process_result(@iut.register_service(@dss_decorated_service))
      end

      def given_dss_indicates_service_inclusion
        @dss.select(@service)
      end

      def given_dss_indicates_service_exclusion
        @dss.deselect(@service)
      end

      def given_dss_error_indication
        @dss.error
      end

      def given_dss_indicates_service_not_known
        @dss.deselect(@service)
      end

      def make_dss_unavailable
        @dss.break
      end
    end
  end
end
