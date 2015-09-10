module ServiceRegistry

  module Test

    ##
    # A factory for building a test orchestrator using an orchestration provider selected from the environment
    #
    # @example cucumber features/support/env.rb
    #   require 'service_registry/test'
    #
    #   Before do
    #     begin
    #       @test = ServiceRegistry::Test::OrchestratorEnvironmentFactory.build
    #     rescue
    #       Cucumber.wants_to_quit = true
    #       raise
    #     end
    #   end
    #
    module OrchestratorEnvironmentFactory

      ##
      # Build a test orchestrator
      #
      # Looks up the test orchestration provider class registered to the {ServiceRegistry::Test::OrchestrationProviderRegistry}
      # with the name provided in the +TEST_ORCHESTRATION_PROVIDER+ environment variable,
      # and returns a new {ServiceRegistry::Test::Orchestrator} initialized with an instance of that provider class.
      #
      # @return [ServiceRegistry::Test::Orchestrator] the test orchestrator
      # @raise [RuntimeError] if the +TEST_ORCHESTRATION_PROVIDER+ environment variable
      #                       does not name a provider known to the {ServiceRegistry::Test::OrchestrationProviderRegistry}
      #
      def self.build
        identifier = ENV["TEST_ORCHESTRATION_PROVIDER"] or raise "missing environment variable: TEST_ORCHESTRATION_PROVIDER"
        registry = ServiceRegistry::Test::OrchestrationProviderRegistry.instance
        provider = registry.lookup(identifier) or raise "unknown test orchestration provider: #{identifier}"
        ServiceRegistry::Test::Orchestrator.new(provider)
      end

    end

  end

end
