require 'net/http'
require 'byebug'

module ServiceRegistry
  module Providers
  	class JUDDISoapBroker
      def initialize(urns)
       	@urns = urns
       	@soap_connector = ServiceRegistry::Providers::Soap4JUDDIConnector.new
       	@soap_xml = ServiceRegistry::Providers::Soap4JUDDIXML.new
      end

      def set_uri(uri)
        @base_uri = uri
      end

      def auth_body
      	@soap_xml.element_with_key_value("authInfo", "authtoken", @auth_token)
      end

      def save_element_bindings(service, bindings, urn, description)
        body = auth_body
        if (not bindings.nil?) and (not (bindings.size == 0))
          bindings.each do |binding|
            access_point = @soap_xml.element_with_value('accessPoint', binding, {'URLType' => extract_binding_url_type(binding)})
            description = @soap_xml.element_with_value('description', description)
            model_instance_details = @soap_xml.element_with_value('tModelInstanceDetails', '')
            bindingTemplate = @soap_xml.element_with_value("bindingTemplate",
            	                                         "#{description}#{access_point}#{model_instance_details}",
            	                                        {'bindingKey' => '', 'serviceKey' => "#{urn}#{service}"})
            body = body + bindingTemplate
          end
        end
        @soap_connector.request_soap(@base_uri, 'publishv2', 'save_binding', body) do | res|
          res.body
        end
      end

      def save_business(key, name, description)
      	body = @soap_xml.element_with_value("name", name)
        if description
          description.each do |desc|
          	xml = @soap_xml.element_with_value('description', desc, {'xml:lang' => 'en'})
            body = "#{body}#{xml}" if desc and not (desc == "")
          end
        end

        businessEntity = @soap_xml.element_with_value('businessEntity', body, {'businessKey' => key})
        @soap_connector.request_soap(@base_uri,
        	           'publishv2', 'save_business',
                     "#{auth_body} #{businessEntity}") do | res|
          extract_business(res.body)
        end
      end

      def get_business(key)
        @soap_connector.request_soap(@base_uri, 'inquiryv2', 'get_businessDetail', @soap_xml.element_with_value('businessKey', key)) do |res|
          extract_business(res.body)
        end
      end

      def find_business(pattern)
      	qualifiers = @soap_xml.element_with_value('findQualifiers', @soap_xml.element_with_value('findQualifier', 'approximateMatch'))
      	xml = @soap_xml.element_with_value('name', pattern)
        @soap_connector.request_soap(@base_uri, 'inquiryv2', 'find_business', "#{qualifiers} #{xml}") do |res|
          extract_business_entries(res.body)
        end
      end	

      def delete_business(key)
      	xml = @soap_xml.element_with_value('businessKey', key)
        @soap_connector.request_soap(@base_uri, 'publishv2', 'delete_business',
        "#{auth_body} #{xml}") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def find_services(pattern)
      	qualifier1 = @soap_xml.element_with_value('findQualifier', 'approximateMatch')
      	qualifier2 = @soap_xml.element_with_value('findQualifier', 'orAllKeys')
      	qualifiers = @soap_xml.element_with_value('findQualifiers', "#{qualifier1}#{qualifier2}")
      	xml = @soap_xml.element_with_value('name', pattern)
        @soap_connector.request_soap(@base_uri, 'inquiryv2', 'find_service', "#{qualifiers} #{xml}") do |res|
          extract_service_entries_elements(res.body, @urns['services'])
        end
      end

      def find_service_components(pattern)
      	qualifier1 = @soap_xml.element_with_value('findQualifier', 'approximateMatch')
      	qualifier2 = @soap_xml.element_with_value('findQualifier', 'orAllKeys')
      	qualifiers = @soap_xml.element_with_value('findQualifiers', "#{qualifier1}#{qualifier2}")
      	xml = @soap_xml.element_with_value('name', pattern)
        @soap_connector.request_soap(@base_uri, 'inquiryv2', 'find_service', "#{qualifiers} #{xml}") do |res|
          extract_service_entries_elements(res.body, @urns['service-components'])
        end
      end

      def find_element_bindings(name, urn)
        @soap_connector.request_soap(@base_uri, 'inquiryv2', 'get_serviceDetail', @soap_xml.element_with_value('serviceKey', "#{urn}#{name}")) do |res|
          extract_bindings(res.body)
        end
      end

      def delete_binding(binding)
      	xml = @soap_xml.element_with_value('bindingKey', binding)
        @soap_connector.request_soap(@base_uri, 'publishv2', 'delete_binding', "#{auth_body} #{xml}") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def get_service_element(name, urn)
        key = name.include?(urn) ? name : "#{urn}#{name}"
        xml = @soap_xml.element_with_value('serviceKey', key)
        @soap_connector.request_soap(@base_uri, 'inquiryv2', 'get_serviceDetail', "#{xml}") do |res|
          { 'name' => extract_name(res.body),
            'description' => extract_descriptions(res.body),
            'definition' => extract_service_definition(res.body) }
        end
      end

      def save_service_element(name, description, definition, urn, business_key)
        # byebug
        service_details = @soap_xml.element_with_value('name', name)
        if description
          description.each do |desc|
          	service_details = service_details + @soap_xml.element_with_value('description', desc, { 'xml:lang' => 'en' }) if desc and not (desc == "")
          end
        end
        if definition and not (definition.strip == "")
	        keyedReference = @soap_xml.element_with_value('keyedReference', '', {'tModelKey' => 'uddi:uddi.org:wadl:types', 'keyName' => 'service-definition', 'keyValue' => definition})
	        service_details = service_details + @soap_xml.element_with_value('categoryBag', keyedReference)
	      end
      	xml = @soap_xml.element_with_value('businessService', service_details, {'businessKey' => business_key, 'serviceKey' => "#{urn}#{name}"})

        body = "#{auth_body} #{xml}"

        @soap_connector.request_soap(@base_uri, 'publishv2', 'save_service', body) do | res|
          extract_service(res.body)
        end
      end

      def delete_service_element(name, urn)
      	service_key = @soap_xml.element_with_value('serviceKey', "#{urn}#{name}")
        @soap_connector.request_soap(@base_uri, 'publishv2', 'delete_service', "#{auth_body} #{service_key}") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def extract_service(soap)
        entries = {}
        entries[@soap_xml.extract_id(soap, 'serviceKey')] = extract_name(soap)
        entries
      end

      def extract_service_entries_elements(soap, urn)
        entries = {}
        entry = soap[/<ns2:serviceInfos>(.*?)<\/ns2:serviceInfos>/, 1]
        while entry do
          service = entry[/<ns2:serviceInfo (.*?)<\/ns2:serviceInfo>/, 1]
          break if service.nil?
          id = @soap_xml.extract_id(service, 'serviceKey')
          entries[id.gsub(urn, "")] = { 'id' => id, 'name' => extract_name(service) } if id.include?(urn)
          entry[/<ns2:serviceInfo (.*?)<\/ns2:serviceInfo>/, 1] = ""
          entry.gsub!("<ns2:serviceInfo </ns2:serviceInfo>", "")
          entry = nil if entry.strip == ""
        end
        { 'services' => entries }
      end

      def extract_business(soap)
        entries = {}
        entries[@soap_xml.extract_id(soap, 'businessKey').gsub(@urns['domains'], "")] = { 'name' => extract_name(soap), 'description' => extract_descriptions(soap) }
        entries
      end

      def extract_business_entries(soap)
        entries = {}
        entry = soap[/<ns2:businessList (.*?)<\/ns2:businessList>/, 1]
        while entry do
          business = entry[/<ns2:businessInfo (.*?)<\/ns2:businessInfo>/, 1]
          break if business.nil?
          business[/<ns2:serviceInfos(.*?)<\/ns2:serviceInfos>/, 1] = "" if business[/<ns2:serviceInfos(.*?)<\/ns2:serviceInfos>/, 1]
          id = @soap_xml.extract_id(entry, 'businessKey')
          entries[id.gsub(@urns['domains'], "")] = { 'id' => id, 'name' => extract_name(business) }
          entry[/<ns2:businessInfo (.*?)<\/ns2:businessInfo>/, 1] = ""
          entry.gsub!("<ns2:businessInfo </ns2:businessInfo>", "")
          entry = nil if entry.strip == ""
        end
        { 'businesses' => entries }
      end

      def extract_errno(soap)
        soap[/<ns2:result errno="(.*?)"\/>/, 1]
      end

      def check_availability
        result = `curl -S #{@base_uri}/juddiv3 2>&1`
        not(result.downcase.include?("fail"))
      end  	

      def authenticate(auth_user, auth_password)
      	@soap_connector.authenticate(auth_user, auth_password)
      end

      def authorize
      	@auth_token = @soap_connector.authorize(@base_uri)
      end

      private

      def extract_service_definition(soap)
        soap[/<ns2:keyedReference tModelKey="uddi:uddi.org:wadl:types" keyName="service-definition" keyValue="(.*?)"\/>/, 1]
      end

      def extract_bindings(soap)
        entries = {}
        entry = soap[/<ns2:bindingTemplates>(.*?)<\/ns2:bindingTemplates>/, 1]
        while entry do
          binding = entry[/<ns2:bindingTemplate (.*?)<\/ns2:bindingTemplate>/, 1]
          break if binding.nil?
          id = @soap_xml.extract_id(binding, 'bindingKey')
          entries[id] = {'access_point' => extract_access_point(binding), 'description' => extract_description(binding)}
          entry[/<ns2:bindingTemplate (.*?)<\/ns2:bindingTemplate>/, 1] = ""
          entry.gsub!("<ns2:bindingTemplate </ns2:bindingTemplate>", "")
          entry = nil if entry.strip == ""
        end
        { 'bindings' => entries }
      end

      def extract_access_point(soap)
        soap[/^.*>(.*?)<\/ns2:accessPoint>/, 1]
      end

      def extract_name(soap)
        name = soap[/<ns2:name xml:lang="en">(.*?)<\/ns2:name>/, 1]
        name ||= soap[/<ns2:name>(.*?)<\/ns2:name>/, 1]
        name
      end

      def extract_description(soap)
        description = soap[/<ns2:description xml:lang="en">(.*?)<\/ns2:description>/, 1]
        description ||= soap[/<ns2:description>(.*?)<\/ns2:description>/, 1]
        description
      end

      def extract_descriptions(soap)
        descriptions = []
        description = soap[/<ns2:description xml:lang="en">(.*?)<\/ns2:description>/, 1]
        while description do
          descriptions << description
          soap.gsub!("<ns2:description xml:lang=\"en\">#{description}<\/ns2:description>", "")
          description = soap[/<ns2:description xml:lang="en">(.*?)<\/ns2:description>/, 1]
        end
        descriptions
      end

      def extract_binding_url_type(binding)
        url_type = nil
        url_type = 'https' if binding.include?('https')
        url_type = 'http' if (not binding.include?('https') and binding.include?('http'))
        url_type ||= 'unknown'
        url_type
      end
    end
  end
end