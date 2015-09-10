require "singleton"

module ServiceRegistry

  module Test

    # The Singleton module deletes the instance on include!
    unless defined?(OrchestrationProviderRegistry)

      ##
      # Singleton registry of test orchestration providers
      #
      # @!method self.instance
      #   The singleton registry instance
      #
      #   @return [ServiceRegistry::Test::OrchestrationProviderRegistry] singleton instance
      #
      class OrchestrationProviderRegistry
        include Singleton

        ##
        # Register a test orchestration provider
        #
        # @param [String] identifier
        #   unique identifier for the test orchestration provider
        # @param [Class] provider
        #   the test orchestration provider class (which should have a default/nullary constructor)
        #
        def register(identifier, provider)
          @providers[identifier] = provider
        end

        ##
        # Look up a test orchestration provider
        #
        # @param [String] identifier
        #   the unique identifier for the test orchestration provider.
        #   The provider must already have been registered with {#register}.
        #
        # @return [Class] the test orchestration provider class
        # @return [nil] if no provider has been registered with the given +identifier+
        #
        def lookup(identifier)
          @providers[identifier]
        end

        # @private
        def initialize
          @providers = {}
        end

      end

    end

  end

end
