require 'singleton'

module ServiceRegistry

  unless defined?(ProviderRegistry)

    ##
    # A singleton registry of configuration service providers
    #
    # @!method self.instance
    #   The singleton registry instance
    #
    #   @return [ServiceRegistry::ProviderRegistry] singleton instance
    #
    class ProviderRegistry

      include Singleton

        ##
        # Register a configuration service provider
        #
        # @param [String] identifier
        #   unique identifier for the configuration service provider
        # @param [Class] provider
        #   the configuration service provider class
        #
        def register(identifier, provider)
          @providers[identifier] = provider
        end

        ##
        # Look up a configuration service provider
        #
        # @param [String] identifier
        #   the unique identifier for the configuration service provider.
        #   The provider must already have been registered with {#register}.
        #
        # @return [Class] the configuration service provider class
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
