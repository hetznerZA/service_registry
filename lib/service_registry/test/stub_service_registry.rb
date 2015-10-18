module ServiceRegistry
  module Test
    class StubServiceRegistry
      attr_reader :dss, :services, :configuration, :available

      def initialize
        @services = {}
        @available = false
      end

      def bootstrap(configuration, configuration_service)
        @configuration = configuration
        return { 'result' => 'error', 'notifications' => ['invalid configuration service'] } if @configuration.nil?
        return { 'result' => 'error', 'notifications' => ['no configuration service'] } if @configuration['CFGSRV_PROVIDER_ADDRESS'].nil?
        return { 'result' => 'error', 'notifications' => ['no identifier'] } if @configuration['CFGSRV_IDENTIFIER'].nil?
        return { 'result' => 'error', 'notifications' => ['invalid identifier'] } if @configuration['CFGSRV_IDENTIFIER'].strip == ""
        return { 'result' => 'error', 'notifications' => ['configuration error'] } if configuration_service.broken?
        return { 'result' => 'error', 'notifications' => ['invalid configuration'] } if configuration_service.configuration.nil?
        @available = true
        return { 'result' => 'success', 'notifications' => ['configuration valid', 'valid identifier'] } if @configuration
      end

      def available?
        @available
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
