require "service_registry"

module ServiceRegistry

  module Test

    ##
    # Encapsulation of configuration service responses
    #
    # Used by test orchestration providers to decouple the test orchestrator from the semantics of API responses.
    #
    module Response

      ##
      # Encapsulates a non-error configuration service response
      #
      # This allows an {ServiceRegistry::Test::OrchestrationProvider}
      # to decouple the {ServiceRegistry::Test::Orchestrator} from the semantics of the configuration service's responses.
      #
      class Success

        ##
        # @param [ServiceRegistry::Configuration, nil] response
        #   a configuration service response, or +nil+ if a {ServiceRegistry::ConfigurationNotFoundError} was raised
        #
        def initialize(response)
          @response = response
        end

        ##
        # Whether the request was allowed
        #
        # @return [true] always
        #
        def allowed?
          true
        end

        ##
        # Whether the request was authorized but failed
        #
        # @return [false] always
        #
        def failed?
          false
        end

        ##
        # Whether the identified configuration was found
        #
        # @return [true] if the +response+ was not +nil+
        # @return [false] if the +response+ was +nil+
        #
        def found?
          not @response.nil?
        end

        ##
        # The configuration data dictionary of the response
        #
        # @return [Hash] if {#found?}
        # @return [nil] if not {#found?}
        #
        def data
          @response and @response.data
        end

        ##
        # The configuration metadata's revision
        #
        # @return [String] if {#found?}
        # @return [nil] if not {#found?}
        #
        def revision
          @response and @response.metadata["revision"]
        end

        ##
        # The configuration metadata
        #
        # @return [Hash] if {#found?}
        # @return [nil] if not {#found?}
        #
        def metadata
          @response and @response.metadata
        end

      end

      ##
      # Encapsulates a configuration service error
      #
      # This allows a {ServiceRegistry::Test::OrchestrationProvider}
      # to decouple the {ServiceRegistry::Test::Orchestrator}
      # from the semantics of the configuration service's error handling.
      #
      class Failure

        ##
        # @param [ServiceRegistry::Error] exception
        #   a configuration service error
        #
        def initialize(exception)
          @exception = exception
        end

        ##
        # Whether the request was allowed
        #
        # @return [true] if the request was allowed
        # @return [false] if the request was a not allowed
        #
        def allowed?
          !@exception.is_a?(ServiceRegistry::AuthorizationError)
        end

        ##
        # Whether the request was authorized but failed
        #
        # @return [true] if the request was allowed but raised a {ServiceRegistry::Error}
        # @return [false] if the request was not allowed or raised an unexpected error
        #
        def failed?
          allowed? and @exception.is_a?(ServiceRegistry::Error)
        end

        ##
        # Whether the identified configuration was found
        #
        # @return [false] always
        #
        def found?
          false
        end

        ##
        # The configuration data dictionary of the response
        #
        # @raise [NotImplementedError] always
        #
        def data
          raise NotImplementedError, "configuration not available after #{@exception.inspect}"
        end

        ##
        # The configuration metadata's revision
        #
        # @raise [NotImplementedError] always
        #
        def revision
          raise NotImplementedError, "revision not available after #{@exception.inspect}"
        end

        ##
        # The configuration metadata's revision
        #
        # @raise [NotImplementedError] always
        #
        def metadata
          raise NotImplementedError, "metadata not available after #{@exception.inspect}"
        end

      end

    end

  end

end
