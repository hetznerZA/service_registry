require "service_registry/base"
require "service_registry/configuration"
require "service_registry/errors"
require "service_registry/factory"
require "service_registry/provider_registry"
require "service_registry/version"

##
# See {ServiceRegistry::Base}.
#
module ServiceRegistry

  ##
  # Creates a new {ServiceRegistry::Base}
  #
  # @see ServiceRegistry::Base#initialize
  #
  def self.new(identifier, token, provider)
    ServiceRegistry::Base.new(identifier, token, provider)
  end

end
