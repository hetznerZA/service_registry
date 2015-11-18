$LOAD_PATH.unshift File.expand_path("../../../lib/service_registry", __FILE__)
require 'byebug'

def require_files
  require "providers/jsend_provider"
  require "test/orchestration_provider_registry"
  Dir.glob(File.expand_path("../../../lib/service_registry/providers/**/*.rb", __FILE__), &method(:require))
  require "test/base_orchestration_provider"
  Dir.glob(File.expand_path("../../../lib/service_registry/test/**/*.rb", __FILE__), &method(:require))
end

require_files

Before do |scenario|
  begin
    feature = scenario.feature.short_name
    @test = ServiceRegistry::Test::OrchestratorEnvironmentFactory.build(feature)
  rescue
    Cucumber.wants_to_quit = true
    raise
  end
end
