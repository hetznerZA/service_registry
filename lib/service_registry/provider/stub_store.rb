require "singleton"

unless defined?(ServiceRegistry::Provider::StubStore)

  module ServiceRegistry

    module Provider

      ##
      # A singleton store for the Stub service provider
      #
      # @example Storing data and metadata
      #
      #   data = {"username" => "sheldonh", "password" => "secret123"}
      #   metadata = {"version" => "1.0.0"}
      #   StubStore.instance.store("acme", data, metadata)
      #
      # @example Fetching data and metadata
      #
      #   data, metadata = StubStore.instance.fetch("acme")
      #   # data     -> {"username" => "sheldonh", "password" => "secret123"}
      #   # metadata -> {"version" => "1.0.0"}
      #
      # @!method self.instance
      #   The singleton registry instance
      #
      #   @return [ServiceRegistry::ProviderRegistry] singleton instance
      #
      class StubStore

        include Singleton

        ##
        # Fetch configuration data and metadata
        #
        # @param [String] identifier the configuration identifier
        #
        # @return [Array<Hash>] data and metadata as a tuple
        #
        def fetch(identifier)
          @configurations.fetch(identifier)
        end

        ##
        # Store configuration data and metadata
        #
        # @param [String] identifier the configuration identifier
        # @param [Hash] data the configuration data
        # @param [Hash] metadata the configuration metadata
        #
        def store(identifier, data, metadata)
          @configurations.store(identifier, [data, metadata])
        end

        ##
        # Delete configuration data and metadata
        #
        # It is not an error to delete non-existent configuration
        #
        # @param [String] identifier the configuration identifier
        #
        def delete(identifier)
          @configurations.delete(identifier)
          nil
        end

        # @private
        def initialize
          @configurations = {}
        end

      end

    end

  end

end
