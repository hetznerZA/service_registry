module ServiceRegistry

  ##
  # Encapsulates identified configuration data and its metadata
  #
  # @attr_reader [String] identifier
  #   the unique identity of some configuration data and its associated metadata
  # @attr_reader [Hash] data
  #   dictionary of probably sensitive configuration data intended for an application, which providers are expected to secure
  # @attr_reader [Hash] metadata
  #   dictionary of data about the configuration data, which providers are not expected to secure
  #
  # @see ServiceRegistry::Base#publish_configuration
  #
  class Configuration

    attr_reader :identifier, :data, :metadata

    ##
    # Returns a new Configuration
    #
    # @param [String] identifier unique identity
    # @param [Hash] data sensitive configuration data
    # @param [Hash] metadata non-sensitive configuration metadata
    #
    def initialize(identifier, data, metadata)
      @identifier = identifier
      @data = data
      @metadata = metadata
    end

  end

end
