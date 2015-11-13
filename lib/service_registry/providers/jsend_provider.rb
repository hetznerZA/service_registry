module ServiceRegistry
  module Providers
    class JSendProvider
      attr_reader :dss

      def associate_dss(dss)
        @dss = dss
      end

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

      def report(status, message, result = nil)
        data ||= {}
        result = { 'result' => result} if not result.is_a? Hash
        result.each do |key, value|
          data[key] = value
        end
        data['notifications'] = message.is_a?(Array) ? message : [ message ] 
        { 'status' => status, 'data' => data }
      end

      def fail(message = nil, data = nil)
        message ||= 'fail'
        report('fail', message, data)
      end

      def fail_data(data = nil)
        fail(nil, data)
      end

      def success_data(data = nil)
        success(nil, data)
      end

      def success(message = nil, data = nil)
        message ||= 'success'
        report('success', message, data)
      end

      def self.has_data?(result, key = nil)
        return false if (result.nil?) or (result['data'].nil?)
        return false if (not key.nil?) and (result['data'][key].nil?)
        true
      end

      def self.notifications_include?(result, pattern)
        return false if not ServiceRegistry::Providers::JSendProvider.has_data?(result, 'notifications')
        result['data']['notifications'].to_s.include?(pattern)
      end      
    end
  end
end
