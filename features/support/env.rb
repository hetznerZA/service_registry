$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)
require 'byebug'
require 'service_registry/test'

Before do
  begin
    @test = ServiceRegistry::Test::StubOrchestrationProvider.new
  rescue
    Cucumber.wants_to_quit = true
    raise
  end
end
