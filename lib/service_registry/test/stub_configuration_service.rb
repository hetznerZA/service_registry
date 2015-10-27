module ServiceRegistry
  module Test
    class StubConfigurationService
      attr_reader :broken, :configuration

      def break
        @broken = true
      end

      def broken?
        @broken
      end

      def clear_configuration
        @configuration = nil
      end

      def configure(configuration)
        @configuration = configuration
      end
    end
  end
end
