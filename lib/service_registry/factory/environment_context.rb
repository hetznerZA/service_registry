module ServiceRegistry

  module Factory

    ##
    # A factory for creating a configuration service bootstrapped from environmental configuration
    #
    # @example Requesting configuration from the {https://github.com/hetznerZA/service_registry-provider-vault Vault service provider}
    #
    #   # With the following in the environment:
    #   #
    #   # CFGSRV_IDENTIFIER="acme"
    #   # CFGSRV_TOKEN="0b2a80f4-54ce-45f4-8267-f6558fee64af"
    #   # CFGSRV_PROVIDER="vault"
    #   # CFGSRV_PROVIDER_ADDRESS="http://127.0.0.1:8200"
    #
    #   # And the following in Gemfile:
    #   #
    #   # source 'https://rubygems.org'
    #   #
    #   # gem 'service_registry-provider-vault'
    #   # gem 'acme_application'
    #
    #   # Now main.rb (or config.ru or whatever) is decoupled from provider
    #   # selection and service configuration:
    #
    #   require 'bundler'
    #   Bundler.require(:default) # Registers the vault provider
    #
    #   service_registry = ServiceRegistry::Factory::EnvironmentContext.create
    #   configuraton = service_registry.request_configuration
    #   AcmeApplication.new(configuration.data).run
    #
    # @attr_reader [String] prefix
    #   prefix for matching environment variable names. Names match if they begin with the prefix and an underscore.
    #
    class EnvironmentContext

      attr_reader :prefix

      ##
      # The default prefix for matching environment variable names
      #
      DEFAULT_PREFIX = "CFGSRV" unless defined?(DEFAULT_PREFIX)

      ##
      # Returns a new factory
      #
      # @param [Hash] env
      #   the string-keyed environment
      # @param [String] prefix
      #   the prefix for matching environment variable names
      #
      # Most consumers will not need to call this method;
      # they can use {.create} which instantiates a factory with default +env+ and +prefix+
      # and uses that internally.
      #
      def initialize(env = ENV, prefix = DEFAULT_PREFIX)
        @env = EnvDict.new(env, prefix)
      end

      ##
      # Create a configuration service bootstrapped with environmental configuration
      #
      # The environment is scanned for {#prefix} matches, within which the following variables are used:
      #
      # [IDENTIFIER] the unique identity of the configuration data
      #              (see {ServiceRegistry::Base#initialize})
      # [TOKEN]      authorization token for the identified configuration data
      #              (see {ServiceRegistry::Base#initialize})
      # [PROVIDER]   the unique identity of the service provider
      #              (see {ServiceRegistry::ProviderRegistry})
      # [PROVIDER_*] configuration options for the service provider
      #              (see service provider documentation)
      #
      # The service provider class is fetched from the {ServiceRegistry::ProviderRegistry} using +PROVIDER+.
      # A service provider instance is then constructed with a dictionary of the +PROVIDER_*+ variables,
      # in which the keys are the name of the variable without +PROVIDER_+, downcased and intern'd.
      #
      # Then a service {ServiceRegistry::Base} is constructed with the +IDENTIFIER+, +TOKEN+ and service provider instance.
      #
      # And finally, the environment is scrubbed of the variables used, to protect them from accidental exposure
      # (e.g. in an exception handler that prints the environment).
      #
      # @return [ServiceRegistry::Base] the configuration service instance created
      # @raise [ProviderNotFoundError] if no service provider has been registered with the name given by +PROVIDER+
      #
      def create
        ServiceRegistry.new(@env[:identifier], @env[:token], provider).tap do
          @env.scrub!
        end
      end

      ##
      # Return a configuration service bootstrapped with environmental configuration
      #
      # Instantiates a new factory with the process +ENV+ and the {DEFAULT_PREFIX} and uses it to create a configuration service.
      #
      # @see #create
      #
      def self.create
        new.create
      end

      private

        def provider
          provider_id = @env[:provider]
          provider_config = @env.subslice(:provider)
          provider_class = ServiceRegistry::ProviderRegistry.instance.lookup(provider_id)
          provider_class or raise ProviderNotFoundError, "provider not registered: #{provider_id}"
          provider_class.new(provider_config)
        end

    end

  end

end
