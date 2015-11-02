module ServiceRegistry
  module Providers
    class JUDDIProvider < JSendProvider
      attr_reader :dss

      def associate_dss(dss)
        @dss = dss
      end
    end
  end
end
