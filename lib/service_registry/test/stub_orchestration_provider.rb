module ServiceRegistry
  module Test
    class StubOrchestrationProvider
      attr_accessor :iut, :result
      attr_reader :dss_decorated_service, :secure_service, :service, :query

      def initialize
        @dss = ServiceRegistry::Test::StubDSS.new
        @iut = ServiceRegistry::Test::StubServiceRegistry.new
        @iut.associate_dss(@dss)
        @dss_decorated_service = { 'id' => 'dss_decorated_service_id', 'description' => 'secure service A', 'meta' => 'dss' }
        @secure_service = { 'id' => 'secure_service', 'description' => 'secure service B' }
      end

      def given_a_service_decorated_with_dss_meta
        @service = @dss_decorated_service
        @iut.register_service(@dss_decorated_service)
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

      def select_service
        @query = 'secure service'
      end

      def query_a_service
        @result = @iut.query_service_by_pattern(@query)
      end

      def make_dss_unavailable
        @dss.break
      end

      def given_dss_indicates_service_not_known
        @dss.deselect(@service)
      end

      def service_included_in_results?
        (not @result.nil?) and (not @result == 'error') and (@result[@service['id']] == @service)
      end
    end
  end
end
