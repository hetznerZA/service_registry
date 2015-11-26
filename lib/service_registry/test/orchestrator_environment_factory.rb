module ServiceRegistry

  module Test

    module OrchestratorEnvironmentFactory
      class MissingEnvironmentVariable < StandardError; end
      class TestOrchestrationProviderNotSupported < StandardError; end

      def self.build(feature)
        identifier = ENV["TEST_ORCHESTRATION_PROVIDER"] or raise MissingEnvironmentVariable.new("missing environment variable: TEST_ORCHESTRATION_PROVIDER")
        registry = ServiceRegistry::Test::OrchestrationProviderRegistry.instance
        provider = registry.lookup(identifier, feature) 
        p = provider.new
        p.inject_iut(ServiceRegistry::Test::OrchestratorEnvironmentFactory::build_iut)
        p.setup
        p
      end

      def self.build_iut
        return ServiceRegistry::Test::StubServiceRegistry.new("http://localhost:8080", nil, nil, { 'username' => 'uddi', 'password' => 'uddi' }) if ENV["TEST_ORCHESTRATION_PROVIDER"] == "stub"
        return ServiceRegistry::Test::TfaServiceRegistry.new("http://localhost:8080", nil, nil, { 'username' => 'uddi', 'password' => 'uddi' }) if ENV["TEST_ORCHESTRATION_PROVIDER"] == "tfa"
        return ServiceRegistry::Test::SoarSrImplementation.new("http://localhost:8080", 'hetzner.co.za', 'hetzner', { 'username' => 'uddi', 'password' => 'uddi' }) if ENV["TEST_ORCHESTRATION_PROVIDER"] == "production"
        raise TestOrchestrationProviderNotSupported.new("Could not build iut for #{ENV["TEST_ORCHESTRATION_PROVIDER"]}")
      end
    end

  end

end
