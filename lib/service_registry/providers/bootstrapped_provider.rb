module ServiceRegistry
  module Providers
    class BootstrappedProvider
      include ServiceRegistry::Providers::DssAssociate
      include ServiceRegistry::Providers::JSender

      def available?
        success_data('available' => @available)
      end      

      def bootstrap(configuration, configuration_service)
        @available = false
        @configuration = configuration
        return fail('invalid configuration service') if @configuration.nil?
        return fail('no configuration service') if @configuration['CFGSRV_PROVIDER_ADDRESS'].nil?
        return fail('no identifier') if @configuration['CFGSRV_IDENTIFIER'].nil?
        return fail('invalid identifier') if @configuration['CFGSRV_IDENTIFIER'].strip == ""
        return fail('configuration error') if configuration_service.broken?
        return fail('no configuration') if configuration_service.configuration.nil?
        return fail('invalid configuration') if configuration_service.configuration.empty?
        @available = true
        return success(['configuration valid', 'valid identifier']) if @configuration
      end
    end
  end
end
