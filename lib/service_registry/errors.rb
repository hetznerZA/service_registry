module ServiceRegistry

  ##
  # The base of the configuration service exception tree
  #
  class Error < StandardError
  end

  ##
  # A configuration service authorization error
  #
  class AuthorizationError < Error
  end

  ##
  # A configuration service provider registry lookup error
  #
  class ProviderNotFoundError < Error
  end

  ##
  #
  # Configuration with the requested identifier was not found
  #
  class ConfigurationNotFoundError < Error
  end

end
