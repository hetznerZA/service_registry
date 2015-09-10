require "time"
require "securerandom"

require "service_registry"

require_relative "stub_store"

module ServiceRegistry

  module Provider

    ##
    # A stub configuration service provider
    #
    # Used to validate the test framework architecture.
    #
    # It is registered into the {ServiceRegistry::ProviderRegistry} with identifier "stub".
    #
    class Stub

      BUILTIN_TOKENS = {
        :consumer  => '64867ebd-6364-0bd3-3fda-81-requestor',
        :publisher => 'f53606cb-7f3c-4432-afe8-44-publisher',
        :nothing   => '2972abd7-b055-4841-8ad1-4a34-nothing',
      } unless defined?(BUILTIN_TOKENS)

      ##
      #
      # @param [Hash] options
      # @option options [String]
      #   :name arbitrary name, used solely for testing factory methods
      #
      def initialize(options = {})
        @name = options[:name] or raise ArgumentError, "missing required argument: name"
        @configurations = StubStore.instance
      end

      ##
      # Request configuration
      #
      # Fetches configuration from the singleton {ServiceRegistry::StubStore}.
      #
      # @return [ServiceRegistry::Configuration] if authorized and found
      # @return [nil] if not found
      # @raise [ServiceRegistry::AuthorizationError] if not authorized for the +:consumer+ role
      #
      # @see ServiceRegistry::Base#request_configuration
      #
      def request_configuration(identifier, token)
        authorize_request(:consumer, token)
        data, metadata = @configurations.fetch(identifier)
        Configuration.new(identifier, data, metadata)
      rescue KeyError
        nil
      end

      ##
      # Publish configuration
      #
      # @param [ServiceRegistry::Configuration] configuration configuration to publish
      #
      # @return [ServiceRegistry::Configuration] published configuration
      # @raise [ServiceRegistry::Error] on failure.
      #
      # @see ServiceRegistry::Base#publish_configuration
      #
      def publish_configuration(configuration, token)
        authorize_request(:publisher, token)
        @configurations.store(configuration.identifier, configuration.data, configuration.metadata)
        configuration
      end

      private

        def authorize_request(role, token)
          raise AuthorizationError.new("missing token") unless token
          raise AuthorizationError.new("authorization failed") unless token == BUILTIN_TOKENS[role]
        end

    end

  end

end

ServiceRegistry::ProviderRegistry.instance.register("stub", ServiceRegistry::Provider::Stub)
