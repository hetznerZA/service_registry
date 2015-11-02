module ServiceRegistry
  module Providers
    class JSendProvider
      def report(status, message, data = nil)
        data ||= {}
        data['notifications'] = message.is_a?(Array) ? message : [ message ] 
        { 'status' => status, 'data' => data }
      end

      def fail(message = nil, data = nil)
        message ||= 'fail'
        report('fail', message, data)
      end

      def success_data(data = nil)
        success(nil, data)
      end

      def success(message = nil, data = nil)
        message ||= 'success'
        report('success', message, data)
      end
    end
  end
end
