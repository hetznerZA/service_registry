require "singleton"

module ServiceRegistry

  module Test

    unless defined?(OrchestrationProviderRegistry)

      class UnknownTestOrchestrator < StandardError; end
      class FeatureNotRegisteredWithTestOrchestratorError < StandardError; end
      
      class OrchestrationProviderRegistry
        include Singleton

        def register(identifier, feature, provider)
          @providers[identifier] = {} if @providers[identifier].nil?
          @providers[identifier][feature] = provider
          true
        end

        def clear_all
          @providers = {}
        end

        def lookup(identifier, feature)
          raise UnknownTestOrchestrator if @providers[identifier].nil?
          raise FeatureNotRegisteredWithTestOrchestratorError if (@providers[identifier][feature].nil?) and (@providers[identifier]["*"].nil?)
          return @providers[identifier][feature] if @providers[identifier][feature]
          @providers[identifier]["*"]
        end

        def list_of_identifiers
          @providers.empty? ? {} : @providers.keys
        end

        def initialize
          @providers = {}
        end

      end

    end

  end

end
