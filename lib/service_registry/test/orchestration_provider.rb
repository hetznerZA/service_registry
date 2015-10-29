module ServiceRegistry
  module Test
    class OrchestrationProvider
      def setup
        @iut = ServiceRegistry::Test::StubServiceRegistry.new
        @notifications = []
        @service_1 = { 'id' => 'valid_service_id_1', 'description' => 'valid service A', 'definition' => nil }
        @service = nil
      end

      def given_a_registered_service
        @service = @service_1
        process_result(@iut.register_service(@service))
      end

      def select_service
        @query = 'secure service'
      end

      def query_a_service
        process_result(@iut.query_service_by_pattern(@query))
      end

      def service_included_in_results?
        success? and (data['services'][@service['id']] == @service)
      end

      def process_result(result)
        @result = result

        @notifications.push(@result['data']['notifications']) if @result and @result.is_a?(Hash) and @result['data'] and @result['data'].is_a?(Hash) and @result['data']['notifications']
        @notifications << @result if @result and not @result.is_a?(Hash)
        @notifications.flatten!
      end

      def success?
        (not @result.nil?) and (not @result['status'].nil?) and (@result['status'] == 'success')
      end

      def data
        @result['data']
      end

      def arrays_the_same?(a, b)
        c = a - b
        d = b - a
        (c.empty? and d.empty?)
      end
    end
  end
end
