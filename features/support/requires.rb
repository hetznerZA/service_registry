$LOAD_PATH.unshift File.expand_path("../../../lib/service_registry", __FILE__)

class Requires
	def self.require_files
	  require "providers/dss_associate"
	  require "providers/bootstrapped_provider"
	  require "providers/juddi_provider"
	  require "test/orchestration_provider_registry"
	  require "test/base_orchestration_provider"
          require "test/base_domain_perspective_orchestration_provider"
          require "test/contacts_orchestration_provider"
          require "test/base_service_orchestration_provider"
          require "test/base_meta_orchestrator"
          require "test/base_dss_orchestration_provider.rb"
          require "test/base_service_component_orchestration_provider.rb"
	  Dir.glob(File.expand_path("../../../lib/service_registry/test/**/*.rb", __FILE__), &method(:require))
	end
end
