require 'net/http'
require 'byebug'

module ServiceRegistry
  module Providers
    class JUDDIProvider < BootstrappedProvider
      def initialize(urns)
        @urns = urns
        @connector = ServiceRegistry::Providers::JUDDISoapConnector.new(@urns['domains'])
      end

      def set_uri(uri)
        @connector.set_uri(uri)
      end

      def authenticate(auth_user, auth_password)
        @connector.authenticate(auth_user, auth_password)
      end

      def available?
        { 'available' => @connector.check_availability }
      end

      # ---- assignments ----
      def assign_service_to_business(name, business_key = @urns['company'])
        result = @juddi.get_service(name)
        service = result['data']
        @connector.save_service_element(service['name'], service['description'], service['definition'], @urns['services'], business_key)
      end

      def assign_service_component_to_business(name, business_key = @urns['company'])
        result = @juddi.get_service_component(name)
        service = result['data']
        @connector.save_service_element(service['name'], service['description'], service['definition'], @urns['service-components'], business_key)
      end

      # ---- services ----

      def get_service(name)
        @connector.get_service_element(name, @urns['services'])
      end

      def save_service(name, description = nil, definition = nil)
        @connector.save_service_element(name, description.is_a?(Array) ? description : [description], definition, @urns['services'], @urns['company'])
      end

      def delete_service(name)
        @connector.delete_service_element(name, @urns['services'])
      end

      def find_services(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"

        @connector.request_soap('inquiryv2', 'find_service',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier> <findQualifier>orAllKeys</findQualifier> </findQualifiers> <name>#{pattern}</name>") do |res|
          @connector.extract_service_entries_elements(res.body, @urns['services'])
        end
      end

      def add_service_uri(service, uri)
        result = service_uris(service)
        existing_id = nil
        result['data']['bindings'] ||= {}
        result['data']['bindings'].each do |binding, detail|
          existing_id = binding if detail['access_point'] == uri
        end
        result = @connector.delete_binding(existing_id) if existing_id
        result = @connector.save_element_bindings(service, [uri], @urns['services'], "service uri") if result['status'] == 'success'
        result
      end

      def remove_service_uri(service, uri)
        result = service_uris(service)
        existing_id = nil
        result['data']['bindings'] ||= {}
        result['data']['bindings'].each do |binding, detail|
          existing_id = binding if detail['access_point'] == uri
        end
        result = @connector.delete_binding(existing_id) if existing_id
        result
      end

      def service_uris(service)
        @connector.find_element_bindings(service, @urns['services'])
      end

      # ---- service components ----

      def get_service_component(name)
        @connector.get_service_element(name, @urns['service-components'])
      end

      def save_service_component(name, description = nil, definition = nil)
        @connector.save_service_element(name, description.is_a?(Array) ? description : [description], definition, @urns['service-components'], @urns['company'])
      end

      def delete_service_component(name)
        @connector.delete_service_element(name, @urns['service-components'])
      end

      def find_service_components(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"

        @connector.request_soap('inquiryv2', 'find_service',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier> <findQualifier>orAllKeys</findQualifier> </findQualifiers> <name>#{pattern}</name>") do |res|
          @connector.extract_service_entries_elements(res.body, @urns['service-components'])
        end
      end

      def save_service_component_uri(service_component, uri)
        authorize
        result = @connector.find_element_bindings(service_component, @urns['service-components'])
        # only one binding for service components
        if result and result['data'] and result['data']['bindings'] and (result['data']['bindings'].size > 0)
          result['data']['bindings'].each do |binding, detail|
            @connector.delete_binding(binding)
          end
        end
        @connector.save_element_bindings(service_component, [uri], @urns['service-components'], "service component")
      end

      def find_service_component_uri(service_component)
        @connector.find_element_bindings(service_component, @urns['service-components'])
      end

      # ---- businesses ----

      def save_business(key, name, description = nil)
        authorize
        body = "<name>#{name}</name>"
        if description
          description.each do |desc|
            body = body + "<urn:description xml:lang='en'>#{desc}</urn:description>" if desc and not (desc == "")
          end
        end

        @connector.request_soap('publishv2', 'save_business',
                     "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessEntity businessKey='#{key}'>#{body}</urn:businessEntity>") do | res|
          @connector.extract_business(res.body)
        end
      end

      def get_business(key)
        @connector.request_soap('inquiryv2', 'get_businessDetail', "<urn:businessKey>#{key}</urn:businessKey>") do |res|
          @connector.extract_business(res.body)
        end
      end

      def find_businesses(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"
        @connector.request_soap('inquiryv2', 'find_business',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier></findQualifiers> <name>#{pattern}</name>") do |res|
          @connector.extract_business_entries(res.body)
        end
      end

      def delete_business(key)
        authorize
        @connector.request_soap('publishv2', 'delete_business',
        "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessKey>#{key}</urn:businessKey>") do |res|
          { 'errno' => @connector.extract_errno(res.body) }
        end
      end

      def business_eq?(business, comparison)
        business == "#{@urns['domains']}#{comparison}"
      end    

      def authorize
        @auth_token = @connector.authorize
      end
    end
  end
end
