require "service_registry/provider/broken"
require "service_registry/provider/stub"
require "service_registry/test/orchestration_provider"
require "service_registry/test/orchestration_provider_registry"

module ServiceRegistry

  module Test

    ##
    # Test orchestration provider for testing the {ServiceRegistry::Provider::Stub} service provider
    #
    # Registered to the {ServiceRegistry::Test::OrchestrationProviderRegistry} as "stub".
    #
    class StubOrchestrationProvider < OrchestrationProvider

      ##
      # The registered identifier of the service provider under test
      #
      # @see ServiceRegistry::Test::OrchestrationProvider#service_provider_id
      #
      def service_provider_id
        "stub"
      end

      ##
      # The configuration for the service provider under test
      #
      # @see ServiceRegistry::Test::OrchestrationProvider#service_provider_configuration
      #
      def service_provider_configuration
        {name: "Stub configuration service provider"}
      end

      ##
      # The service provider under test
      #
      # @see ServiceRegistry::Test::OrchestrationProvider#service_provider
      #
      def service_provider
        ServiceRegistry::Provider::Stub.new(service_provider_configuration)
      end

      ##
      # A broken service provider
      #
      # @see ServiceRegistry::Test::OrchestrationProvider#broken_service_provider
      #
      def broken_service_provider
        ServiceRegistry::Provider::Broken.new
      end

      ##
      # Provide a token that authorizes a role
      #
      # The token is taken from {ServiceRegistry::Provider::Stub::BUILTIN_TOKENS}
      #
      # @see ServiceRegistry::Test::OrchestrationProvider#token_for
      #
      def token_for(role)
        ServiceRegistry::Provider::Stub::BUILTIN_TOKENS[role]
      end

      ##
      # Delete configuration data
      #
      # @see ServiceRegistry::Test::OrchestrationProvider#delete_configuration
      #
      def delete_configuration
        ServiceRegistry::Provider::StubStore.instance.delete(@identifier)
      end

    end

  end

end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", ServiceRegistry::Test::StubOrchestrationProvider)
