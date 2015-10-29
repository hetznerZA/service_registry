$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)
require 'byebug'
require 'service_registry/test'

Before do |scenario|
  begin
    feature = scenario.feature.short_name
    @test = ServiceRegistry::Test::OrchestratorEnvironmentFactory.build(feature)
    @test.setup
  rescue
    Cucumber.wants_to_quit = true
    raise
  end
end
