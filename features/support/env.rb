$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)
require 'service_registry/test'

Before do
  begin
    @test = ServiceRegistry::Test::OrchestratorEnvironmentFactory.build
  rescue
    Cucumber.wants_to_quit = true
    raise
  end
end
