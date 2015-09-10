Dir.glob(File.expand_path("../test/**/*.rb", __FILE__), &method(:require))

module ServiceRegistry

  ##
  # Support module for testing configuration service implementations
  #
  # The following are used directly by the cucumber test suite, and
  # should not be of immediate interest to implementors:
  #
  # * {ServiceRegistry::Test::Orchestrator} the declarative test orchestration API
  # * {ServiceRegistry::Test::OrchestratorEnvironmentFactory} test orchestrator factory
  # * {ServiceRegistry::Test::StubOrchestrationProvider} imperative test orchestration provider
  #   for the {ServiceRegistry::Provider::Stub Stub} configuration service provider
  #
  # The following are of interest to implementors:
  #
  # * {ServiceRegistry::Test::OrchestrationProviderRegistry} registry of imperative test orchestration providers
  # * {ServiceRegistry::Test::Response} configuration service response wrappers
  # * {ServiceRegistry::Test::OrchestrationProvider} abstract imperative test orchestration provider
  #
  module Test

  end

end
