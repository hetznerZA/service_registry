require 'net/http'
require 'byebug'

module ServiceRegistry
  module Providers
    class JUDDIProvider < BootstrappedProvider
      def initialize(urns, broker)
        @urns = urns
        @broker = broker
      end

      def broker
        @broker
      end

      def assign_service_to_business(name, business_key = @urns['company'])
        @broker.authorize
        result = @juddi.get_service(name)
        service = result['data']
        @broker.save_service_element(service['name'], service['description'], service['definition'], @urns['services'], business_key)
      end

      def assign_service_component_to_business(name, business_key = @urns['company'])
        @broker.authorize
        result = @juddi.get_service_component(name)
        service = result['data']
        @broker.save_service_element(service['name'], service['description'], service['definition'], @urns['service-components'], business_key)
      end

      def get_service(name)
        @broker.get_service_element(name, @urns['services'])
      end

      def save_service(name, description = nil, definition = nil)
        @broker.authorize
        @broker.save_service_element(name, description.is_a?(Array) ? description : [description], definition, @urns['services'], @urns['company'])
      end

      def delete_service(name)
        @broker.authorize
        @broker.delete_service_element(name, @urns['services'])
      end

      def find_services(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"

        @broker.find_services(pattern)
      end

      def add_service_uri(service, uri)
        result = remove_service_uri(service, uri)
        result = save_service_uri(service, uri) if result['status'] == 'success'
        result
      end

      def remove_service_uri(service, uri)
        @broker.authorize
        result = service_uris(service)
        existing_id = has_existing_binding?(result['data']['bindings'], uri) if has_bindings?(result)
        result = @broker.delete_binding(existing_id) if existing_id
        result
      end

      def service_uris(service)
        @broker.find_element_bindings(service, @urns['services'])
      end

      def get_service_component(name)
        @broker.get_service_element(name, @urns['service-components'])
      end

      def save_service_component(name, description = nil, definition = nil)
        @broker.authorize
        @broker.save_service_element(name, description.is_a?(Array) ? description : [description], definition, @urns['service-components'], @urns['company'])
      end

      def delete_service_component(name)
        @broker.authorize
        @broker.delete_service_element(name, @urns['service-components'])
      end

      def find_service_components(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"

        @broker.find_service_components(pattern)
      end

      def save_service_component_uri(service_component, uri)
        @broker.authorize
        result = @broker.find_element_bindings(service_component, @urns['service-components'])
        # only one binding for service components
        delete_existing_bindings(result['data']['bindings']) if has_bindings?(result)
        @broker.save_element_bindings(service_component, [uri], @urns['service-components'], "service component")
      end

      def find_service_component_uri(service_component)
        @broker.find_element_bindings(service_component, @urns['service-components'])
      end

      def save_business(key, name, description = nil, contacts = nil)
        @broker.authorize
        @broker.save_business(key, name, description, contacts)
      end

      def get_business(key)
        @broker.get_business(key)
      end

      def find_businesses(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"
        @broker.find_business(pattern)
      end

      def delete_business(key)
        @broker.authorize
        @broker.delete_business(key)
      end

      private

      def delete_existing_bindings(bindings)
        bindings.each do |binding, detail|
          @broker.delete_binding(binding)
        end
      end

      def has_bindings?(result)
        result and result['data'] and result['data']['bindings'] and (result['data']['bindings'].size > 0)
      end

      def has_existing_binding?(bindings, uri)
        bindings.each do |binding, detail|
          return binding if detail['access_point'] == uri
        end
        nil
      end

      def save_service_uri(service, uri)
        @broker.authorize
        @broker.save_element_bindings(service, [uri], @urns['services'], "service uri") 
      end
    end
  end
end
