require "securerandom"

module ServiceRegistry

  ##
  # The configuration service API
  #
  # See {file:README.rdoc} for a summary of the service, including links to user stories.
  #
  # It is recommended that consumers use a {ServiceRegistry::Factory} to create and configure the service.
  #
  class Base

    ##
    # Creates a new configuration service API instance
    #
    # @param [String] identifier
    #   the unique identity of some configuration data and its associated metadata.
    #   It might be the name of a service or service component. It might include an environment label
    #   (e.g. production, staging, etc.) For example:
    #
    #   * billing.acme.com
    #   * billing-web1.acme.com
    #   * billing/production/web1
    # @param [String] token
    #   opaque string representing authority to access the configuration data and associated metadata.
    #   Interpretation of the token is provider-dependent; it is opaque to the API and client.
    # @param [Object] provider
    #   a configured service provider instance, to which requests will be delegated.
    #
    def initialize(identifier, token, provider)
      @identifier = identifier
      @token = token
      @provider = provider
    end

    ##
    # Requests the configuration data and metadata
    #
    # Delegates the request to the configured +provider+.
    #
    # @return [ServiceRegistry::Configuration] object containing the configuration data, metadata and identifier
    # @raise [ServiceRegistry::ConfigurationNotFoundError] if no configuration was found for the configured +identifier+
    # @raise [ServiceRegistry::Error] if the request failed
    #
    def request_configuration
      @provider.request_configuration(@identifier, @token) or
        raise ConfigurationNotFoundError, "configuration not found for identifier: #{@identifier}"
    end

    ##
    # Publishes configuration data and metadata
    #
    # The +metadata+ is decorated with the following keys:
    #
    # * "timestamp" - the current UTC time in ISO8601 format
    # * "revision"  - a UUID for this publication
    #
    # Delegates the request to the configured +provider+. The provider may further decorate the +metadata+.
    #
    # It is recommended that both the +data+ and +metadata+ dictionaries use strings as keys,
    # and that values be limited to those that can be serialized to JSON.
    #
    # @param [Hash] data
    #   dictionary of probably sensitive configuration data intended for an application, which providers are expected to secure
    # @param [Hash] metadata
    #   dictionary of data about the configuration data, which providers are not expected to secure
    #
    # @return [ServiceRegistry::Configuration] object containing the configuration data, decorated metadata and identifier
    # @raise [ServiceRegistry::Error] if publication failed
    #
    def publish_configuration(data, metadata = {})
      dictionary?(data) or raise ServiceRegistry::Error, "data must be a dictionary"
      dictionary?(metadata) or raise ServiceRegistry::Error, "metadata must be a dictionary"

      metadata = decorate(metadata)
      configuration = Configuration.new(@identifier, data, metadata)
      @provider.publish_configuration(configuration, @token)
    end

    private

      def dictionary?(o)
        o.respond_to?(:to_hash) or o.respond_to?(:to_h)
      end

      def decorate(metadata)
        revision = SecureRandom.uuid
        metadata = metadata.merge("revision" => revision) unless metadata["revision"]
        metadata = metadata.merge("timestamp" => Time.now.utc.iso8601) unless metadata["timestamp"]
      end

  end

end
