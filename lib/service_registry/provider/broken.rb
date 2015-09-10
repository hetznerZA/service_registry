module ServiceRegistry

  module Provider

    ##
    # A stub broken {ServiceRegistry::Base} service provider
    #
    # Used to validate the test framework architecture.
    #
    class Broken

      ##
      # @raise [ServiceRegistry::Error] always
      #
      def publish_configuration(configuration, token)
        raise ServiceRegistry::Error, "error requested by test"
      end

      ##
      # @raise [ServiceRegistry::Error] always
      #
      def request_configuration(identifier, token)
        raise ServiceRegistry::Error, "error requested by test"
      end

    end

  end

end
