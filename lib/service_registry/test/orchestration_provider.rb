require 'cucumber/errors'
require 'service_registry'

module ServiceRegistry

  module Test

    ##
    # @abstract
    #   It is a base provider for the test {ServiceRegistry::Test::Orchestrator}.
    #
    #   Extend this class if you want your test orchestration provider toconstrain your implementation's interface
    #   to work as a configuration service provider.
    #   If you have no intention of plugging your implementation into {ServiceRegistry::Base},
    #   build your own test orchestration provider from scratch, using {ServiceRegistry::Test::Orchestrator}
    #   and {ServiceRegistry::Test::StubOrchestrationProvider} as a guide.
    #
    #   Extensions should implement:
    #
    #   * {#service_provider_id}
    #   * {#service_provider_configuration}
    #   * {#service_provider}
    #   * {#broken_service_provider}
    #   * {#token_for}
    #   * {#delete_configuration}
    #
    class OrchestrationProvider

      ACTIVITY_ROLE_MAP = {
        :requesting_configurations => :consumer,
        :publishing_configurations => :publisher,
        :nothing => :none # if possible, provide credentials that don't allow operations on the configuration identifier
      } unless defined?(ACTIVITY_ROLE_MAP)
      ROLES = ACTIVITY_ROLE_MAP.values unless defined?(ROLES)

      ##
      # The provider is always initialized with the same configuration +identifier+
      #
      def initialize
        @identifier = "acme"
      end

      ##
      # The registered identifier of the service provider under test
      #
      # @return [String] the +identifier+ with which the service provider is registered
      #                  into the {ServiceRegistry::ProviderRegistry}
      #
      def service_provider_id
        raise NotImplementedError, "#{self.class} must implement service_provider_id"
      end

      ##
      # The configuration for the service provider under test
      #
      # @return [Hash] dictionary of keyword arguments that can be passed to the constructor of the service provider class
      #
      def service_provider_configuration
        raise NotImplementedError, "#{self.class} must implement service_provider_configuration"
      end

      ##
      # The service provider under test
      #
      # @return [Object] a provider to be plugged into {ServiceRegistry::Base}
      #
      def service_provider
        raise NotImplementedError, "#{self.class} must implement service_provider"
      end

      ##
      # A broken service provider
      #
      # @return [Object] a provider to be plugged into {ServiceRegistry::Base}.
      #                  The service provider's +publish_configuration+ and +request_configuration+ methods
      #                  must raise an {ServiceRegistry::Error} other than {ServiceRegistry::AuthorizationError}.
      #
      def broken_service_provider
        raise NotImplementedError, "#{self.class} must implement broken_service_provider"
      end

      ##
      # Delete configuration data
      #
      # Deleting non-existent configuration should not produce an error.
      # The +@identifier+ instance variable may be used to identify the configuration to delete,
      # but +@token+ should not be used, because it may not be sufficiently authorized.
      #
      # @return [nil] always
      #
      def delete_configuration
        raise NotImplementedError, "#{self.class} must implement delete_configuration"
      end

      ##
      # Provide a token that authorizes a role
      #
      # Valid roles are:
      #
      # * +:consumer+
      # * +:publisher+
      # * +:nothing+
      #
      # Note that a token should be returned for +:nothing+, but the token should
      # not be authorized to consume or publish to the +identifier+.
      #
      # @return [String] a token
      #
      def token_for(role)
        raise NotImplementedError, "#{self.class} must implement token_for(role)"
      end

      ##
      # @see ServiceRegistry::Test::Orchestrator#authorize
      #
      def authorize(role)
        @token = token_for(role)
      end

      ##
      # @see ServiceRegistry::Test::Orchestrator#deauthorize
      #
      def deauthorize
        @token = nil
      end

      ##
      # @see ServiceRegistry::Test::Orchestrator#given_metadata
      #
      def given_metadata
        @metadata = {"version" => "1.0"}
      end

      ##
      # @see ServiceRegistry::Test::Orchestrator#given_existing_configuration
      #
      def given_existing_configuration
        authorized_as(:publisher) do
          @existing_configuration = publish_configuration
        end
      end

      ##
      # @see ServiceRegistry::Test::Orchestrator#given_invalid_configuration
      #
      def given_invalid_configuration
        @configuration = "This should be an object!"
      end

      ##
      # @see ServiceRegistry::Test::Orchestrator#given_missing_configuration
      #
      def given_missing_configuration
        authorized_as(:publisher) do
          delete_configuration
          @existing_configuration = nil
        end
      end

      ##
      # @see ServiceRegistry::Test::Orchestrator#existing_revision
      #
      def existing_revision
        @existing_configuration.revision
      end

      ##
      # Request configuration
      #
      # Request configuration from the configuration service.
      # This exercises the configuration service provider under test through the configuration service API.
      #
      # The response from the service is wrapped in a test {ServiceRegistry::Test::response}.
      #
      # @return [ServiceRegistry::Test::Response]
      #
      # @see ServiceRegistry::Base#request_configuration
      #
      def request_configuration
        wrap_response do
          @requested_configuration = service.request_configuration
        end
      end

      ##
      # Publish configuration
      #
      # Publish configuration through the configuration service.
      # This exercises the configuration service provider under test through the configuration service API.
      #
      # The response from the service is wrapped in a test {ServiceRegistry::Test::response}.
      #
      # @return [ServiceRegistry::Test::Response]
      #
      # @see ServiceRegistry::Base#publish_configuration
      #
      def publish_configuration
        wrap_response do
          if @metadata
            service.publish_configuration(configuration, @metadata)
          else
            service.publish_configuration(configuration)
          end
        end
      end

      ##
      # Configuration was found for requested identifier
      #
      # @return [true] if last request returned configuration with the +identifier+.
      #
      # @see ServiceRegistry::Test::Orchestrator#configuration_found_for_identifier?
      #
      def configuration_found_for_identifier?
        @requested_configuration.identifier == @identifier
      end

      ##
      # Arrange for the next publish or request operation to fail
      #
      # This is done by using a {#broken_service_provider} to service the next operation.
      #
      # @return [nil]
      #
      def fail_next_request
        @fail_next = true
      end

      ##
      # Mark a cucumber step as pending
      #
      # @raise [Cucumber::Pending] always
      #
      def pending(message = nil)
        if message
          raise Cucumber::Pending, message
        else
          raise Cucumber::Pending
        end
      end

      private

        def configuration
          @configuration ||= {"verbose" => true}
        end

        def service
          provider = if @fail_next
                       @fail_next = false
                       broken_service_provider
                     else
                       service_provider
                     end
          ServiceRegistry.new(@identifier, @token, provider)
        end

        def authorized_as(role)
          restore_token = @token
          authorize(role)
          yield.tap do
            @token = restore_token
          end
        end

        def wrap_response # :nodoc:
          begin
            ServiceRegistry::Test::Response::Success.new(yield)
          rescue ServiceRegistry::ConfigurationNotFoundError
            ServiceRegistry::Test::Response::Success.new(nil)
          rescue ServiceRegistry::Error => e
            ServiceRegistry::Test::Response::Failure.new(e)
          end
        end

    end

  end

end
