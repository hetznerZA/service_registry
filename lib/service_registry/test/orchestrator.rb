require 'service_registry'

module ServiceRegistry

  module Test

    ##
    # The declarative test orchestration API
    #
    # This is the declarative API that describes what must be done to test a
    # configuration service provider. It catalogues all the services that the
    # cucumber step definitions expect from a test orchestration provider.
    #
    # It keeps no domain state, because that would couple it to the
    # service implementation. By making no assumptions at all about the API
    # or data, it allows implementors to produce service implementations
    # that do not adhere to the anticipated {ServiceRegistry::Base} API,
    # by writing their own test orchestration provider from scratch
    # instead of extending {ServiceRegistry::Test::OrchestrationProvider}.
    #
    # However, implementors who are trying to produce {ServiceRegistry::Base}
    # providers should extend {ServiceRegistry::Test::OrchestrationProvider},
    # which anticipates a compatible provider API.
    #
    # Note that the +@response+ instance variable is not domain state; it is
    # a test artifact ({ServiceRegistry::Test::Response} or similar)
    # that orchestration providers use to wrap responses from the configuration service.
    #
    class Orchestrator

      ##
      #
      # @param [Class] provider_class
      #   the test orchestration provider class, which should have a default/nullary constructor
      #
      def initialize(provider_class)
        @provider = provider_class.new
      end

      ##
      # Include metadata in the next publishing operation
      #
      def given_metadata
        @provider.given_metadata
      end

      ##
      # Arrange a published configuration fixture
      #
      def given_existing_configuration
        @provider.given_existing_configuration
      end

      ##
      # Use invalid configuration data in the next publishing operation
      #
      def given_invalid_configuration
        @provider.given_invalid_configuration
      end

      ##
      # Delete any existing configuration
      #
      def given_missing_configuration
        @provider.given_missing_configuration
      end

      ##
      # Return the revision of a published configuration fixture
      #
      # E.g. as arranged by {#given_existing_configuration}.
      #
      # @todo replace with predicate: this exposes domain state
      #
      def existing_revision
        @provider.existing_revision
      end

      ##
      # Authorize the next publish or request activity
      #
      # @param [Symbol] activity
      #   Valid activities (as per {ServiceRegistry::Test::OrchestrationProvider::ACTIVITY_ROLE_MAP}) are:
      #
      #   * +:requesting_configurations+
      #   * +:publishing_configurations+
      #   * +:nothing+
      #
      # Where possible, the test orchestration provider should authorize +:nothing+
      # by providing valid credentials that don't allow operations on the
      # configuration +identifier+ that it tests against.
      #
      def authorize(activity)
        role = role_for(activity) or raise "unknown authorizable activity #{activity.inspect}"
        @provider.authorize(role)
      end

      ##
      # Remove any previous authorization
      #
      # E.g. as arranged by {#authorize}.
      #
      def deauthorize
        @provider.deauthorize
      end

      ##
      # Request configuration from the service under test
      #
      # The test orchestration provider is expected to wrap the response in a {ServiceRegistry::Test::Response}
      # (or simimlar) and return that.
      #
      def request_configuration
        @response = @provider.request_configuration
      end

      ##
      # Publish configuration through the service under test
      #
      # The test orchestration provider is expected to wrap the response in a {ServiceRegistry::Test::Response}
      # (or simimlar) and return that.
      #
      def publish_configuration
        @response = @provider.publish_configuration
      end

      ##
      # Configuration for the requested identifier was found
      #
      # The test orchestration provider should verify that the returned configuration is for the requested identifier.
      #
      def configuration_found_for_identifier?
        @provider.configuration_found_for_identifier?
      end

      ##
      # Whether the last publish or request was allowed
      #
      # @see ServiceRegistry::Test::Response::Success#allowed?
      # @see ServiceRegistry::Test::Response::Failure#allowed?
      #
      def request_allowed?
        @response.allowed?
      end

      ##
      # Whether the last publish or request was allowed but failed
      #
      # @see ServiceRegistry::Test::Response::Success#failed?
      # @see ServiceRegistry::Test::Response::Failure#failed?
      #
      def request_failed?
        @response.failed?
      end

      ##
      # True if the last request not return configuration data
      #
      # @see ServiceRegistry::Test::Response::Success#found?
      # @see ServiceRegistry::Test::Response::Failure#found?
      #
      def request_not_found?
        not @response.found?
      end

      ##
      # True if the last request did consuming operation did not return data
      #
      # @see ServiceRegistry::Test::Response::Success#found?
      # @see ServiceRegistry::Test::Response::Failure#found?
      #
      # @todo distinguish {#request_not_matched?} to mean "found data, but filtered out by metadata filter"
      #
      def request_not_matched?
        not @response.found?
      end

      ##
      # The last published or consumed configuration data
      #
      # @return [Hash] configuration data (not a {ServiceRegistry::Configuration} object)
      #
      # @todo replace with predicate: this exposes domain state
      #
      def published_configuration
        @response.data
      end
      alias :requested_configuration :published_configuration

      ##
      # The revision of the last published or consumed configuration metadata
      #
      # @return [String] metadata revision
      #
      # @todo replace with predicate: this exposes domain state
      #
      def published_revision
        @response.revision
      end

      ##
      # The last published metadata
      #
      # @return [Hash] configuration metadata
      #
      # @todo replace with predicate: this exposes domain state
      #
      def published_metadata
        @response.metadata
      end

      ##
      # Arrange for the next publication operation to fail
      #
      def given_publication_failure
        @provider.fail_next_request
      end

      ##
      # Arrange for the next consuming operation to fail
      #
      def given_request_failure
        @provider.fail_next_request
      end

      ##
      # Arrange environmental service configuration
      #
      # Environmental service configuration is configuration for bootstrapping
      # a configuration service and provider.
      #
      # @todo replace with declarative test that delegates to orchestration provider
      #
      def given_environmental_service_configuration
        sp_env = @provider.service_provider_configuration.inject({}) do |m, (k, v)|
          m["CFGSRV_PROVIDER_#{k.to_s.upcase}"] = v
          m
        end
        @env = {
          "CFGSRV_IDENTIFIER" => "acme",
          "CFGSRV_TOKEN" => "ea81cbfb-221c-41ad-826e-d3eff6342345",
          "CFGSRV_PROVIDER" => @provider.service_provider_id,
        }.merge(sp_env)
      end

      ##
      # Bootstrap a configuration service environmentally
      #
      # Environmental service configuration (as arranged by {#given_environmental_service_configuration})
      # is given to an {ServiceRegistry::Factory::EnvironmentContext} factory to create a service configuration instance.
      #
      # @todo replace with declarative test that delegates to orchestration provider
      #
      def bootstrap_service_registry_environmentally
        factory = ServiceRegistry::Factory::EnvironmentContext.new(@env, "CFGSRV")
        @service = factory.create
      end

      ##
      # Tests that a bootstrapped configuration service is functional
      #
      # @todo replace with declarative test that delegates to orchestration provider
      #
      def bootstrapped_service_registry_functional?
        response = begin
          ServiceRegistry::Test::Response::Success.new(@service.request_configuration)
        rescue ServiceRegistry::Error => e
          ServiceRegistry::Test::Response::Failure.new(e)
        end
        !response.failed?
      end

      ##
      # Tests that environmental service configuration is scrubbed
      #
      # @todo replace with declarative test that delegates to orchestration provider
      #
      def environmental_service_configuration_scrubbed?
        !@env.include?("CFGSRV_TOKEN")
      end

      private

        def role_for(activity)
          ServiceRegistry::Test::OrchestrationProvider::ACTIVITY_ROLE_MAP[activity]
        end
    end

  end

end
