$LOAD_PATH.unshift File.expand_path("../../../lib/service_registry", __FILE__)
require 'byebug'

def require_files
  Dir.glob(File.expand_path("../../../lib/service_registry/providers/**/*.rb", __FILE__), &method(:require))
  require "test/stub_orchestration_provider"
  require "test/production_orchestration_provider"
  Dir.glob(File.expand_path("../../../lib/service_registry/test/**/*.rb", __FILE__), &method(:require))
end

require_files

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
