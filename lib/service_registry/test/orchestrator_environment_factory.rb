module ServiceRegistry

  module Test

    module OrchestratorEnvironmentFactory
      class MissingEnvironmentVariable < StandardError; end

      def self.build(feature)
        identifier = ENV["TEST_ORCHESTRATION_PROVIDER"] or  raise MissingEnvironmentVariable.new("missing environment variable: TEST_ORCHESTRATION_PROVIDER")
        registry = ServiceRegistry::Test::OrchestrationProviderRegistry.instance
        provider = registry.lookup(identifier, feature) 
        provider.new
      end

    end

  end

end
