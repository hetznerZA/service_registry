module ServiceRegistry
  module Providers
    class JUDDIProvider < JSendProvider
      def available?
        if @available
          result = `curl -S http://localhost:8080/juddiv3 2>&1`
          @available = not(result.downcase.include?("fail"))
        end
        success_data('available' => @available)
      end
    end
  end
end
