module ServiceRegistry
  module Test
    class StubServiceRegistry
      attr_reader :dss, :services

      def initialize
        @services = {}
      end

      def register_service(service)
        @services[service['id']] = service
      end

      def associate_dss(dss)
        @dss = dss
      end

      def query_service_by_pattern(pattern)
        result = {}
        @services.each do |key, service|
          result[service['id']] = service if service['description'].include?(pattern) and check_dss(service)
        end
        result
      end

      private

      def check_dss(service)
        return true if not service['meta'].include?('dss')
        result = @dss.query(service['id'])
        return false if result.nil? or result == 'error'
        result
      end
    end
  end
end
