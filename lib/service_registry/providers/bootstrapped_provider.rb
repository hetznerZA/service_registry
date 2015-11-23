module ServiceRegistry
  module Providers
    class BootstrappedProvider
      include ServiceRegistry::Providers::JSender

      def available?
        success_data('available' => @available)
      end      

      def bootstrap(configuration_service_details, configuration_service)
        @available = false
        return fail('invalid configuration service') if configuration_service_details.nil?
        return fail('no configuration service') if configuration_service_details['CFGSRV_PROVIDER_ADDRESS'].nil?
        return fail('no identifier') if configuration_service_details['CFGSRV_IDENTIFIER'].nil?
        return fail('invalid identifier') if configuration_service_details['CFGSRV_IDENTIFIER'].strip == ""
        @configuration = configuration_service.request_configuration
        return fail('no configuration') if @configuration.nil?
        return fail('invalid configuration') if @configuration.empty?
        @available = true
        return success(['configuration valid', 'valid identifier']) if @configuration
      rescue => ex
        return fail("configuration error")
      end

      def configuration
        @configuration
      end
    end
  end
end
