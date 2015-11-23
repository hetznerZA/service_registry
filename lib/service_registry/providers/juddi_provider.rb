require 'net/http'
require 'byebug'

module ServiceRegistry
  module Providers
    class JUDDIProvider < BootstrappedProvider
      def initialize(urns)
        @auth_user = ''
        @auth_password = ''
        @urns = urns
      end

      def set_uri(uri)
        @base_uri = uri
      end

      def authenticate(auth_user, auth_password)
        @auth_user = auth_user
        @auth_password =auth_password
      end

      def available?
        { 'available' => check_availability }
      end

      # ---- assignments ----
      def assign_service_to_business(name, business_key)
        result = @juddi.get_service(name)
        service = result['data']
        save_service_element(service['name'], ervice['description'], service['definition'], @urns['services'], business_key)
      end

      def assign_service_component_to_business(name, business_key)
        result = @juddi.get_service_component(name)
        service = result['data']
        save_service_element(service['name'], ervice['description'], service['definition'], @urns['service-components'], business_key)
      end

      # ---- services ----

      def get_service(name)
        get_service_element(name, @urns['services'])
      end

      def save_service(name, description = nil, definition = nil)
        save_service_element(name, description.is_a?(Array) ? description : [description], definition, @urns['services'])
      end

      def delete_service(name)
        delete_service_element(name, @urns['services'])
      end

      def find_services(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"

        request_soap('inquiryv2', 'find_service',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier> <findQualifier>orAllKeys</findQualifier> </findQualifiers> <name>#{pattern}</name>") do |res|
          extract_service_entries_elements(res.body, @urns['services'])
        end
      end

      def add_service_uri(service, uri)
        result = service_uris(service)
        existing_id = nil
        result['data']['bindings'] ||= {}
        result['data']['bindings'].each do |binding, detail|
          existing_id = binding if detail['access_point'] == uri
        end
        result = delete_binding(existing_id) if existing_id
        result = save_element_bindings(service, [uri], @urns['services'], "service uri") if result['status'] == 'success'
        result
      end

      def remove_service_uri(service, uri)
        result = service_uris(service)
        existing_id = nil
        result['data']['bindings'] ||= {}
        result['data']['bindings'].each do |binding, detail|
          existing_id = binding if detail['access_point'] == uri
        end
        result = delete_binding(existing_id) if existing_id
        result
      end

      def service_uris(service)
        find_element_bindings(service, @urns['services'])
      end

      # ---- service components ----

      def get_service_component(name)
        get_service_element(name, @urns['service-components'])
      end

      def save_service_component(name, description = nil, definition = nil)
        save_service_element(name, description.is_a?(Array) ? description : [description], definition, @urns['service-components'])
      end

      def delete_service_component(name)
        delete_service_element(name, @urns['service-components'])
      end

      def find_service_components(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"

        request_soap('inquiryv2', 'find_service',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier> <findQualifier>orAllKeys</findQualifier> </findQualifiers> <name>#{pattern}</name>") do |res|
          extract_service_entries_elements(res.body, @urns['service-components'])
        end
      end

      def save_service_component_uri(service_component, uri)
        authorize
        result = find_element_bindings(service_component, @urns['service-components'])
        # only one binding for service components
        if result and result['data'] and result['data']['bindings'] and (result['data']['bindings'].size > 0)
          result['data']['bindings'].each do |binding, detail|
            delete_binding(binding)
          end
        end
        save_element_bindings(service_component, [uri], @urns['service-components'], "service component")
      end

      def find_service_component_uri(service_component)
        find_element_bindings(service_component, @urns['service-components'])
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

        request_soap('publishv2', 'save_business',
                     "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessEntity businessKey='#{key}'>#{body}</urn:businessEntity>") do | res|
          extract_business(res.body)
        end
      end

      def get_business(key)
        request_soap('inquiryv2', 'get_businessDetail', "<urn:businessKey>#{key}</urn:businessKey>") do |res|
          extract_business(res.body)
        end
      end

      def find_businesses(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"
        request_soap('inquiryv2', 'find_business',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier></findQualifiers> <name>#{pattern}</name>") do |res|
          extract_business_entries(res.body)
        end
      end

      def delete_business(key)
        authorize
        request_soap('publishv2', 'delete_business',
        "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessKey>#{key}</urn:businessKey>") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def business_eq?(business, comparison)
        business == "#{@urns['domains']}#{comparison}"
      end    

    private
      def save_element_bindings(service, bindings, urn, description)
        authorize
        body = "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo>"
        if (not bindings.nil?) and (not (bindings.size == 0))
          bindings.each do |binding|
            url_type = nil
            url_type = 'https' if binding.include?('https')
            url_type = 'http' if (not binding.include?('https') and binding.include?('http'))
            url_type ||= 'unknown'
            body = body + "<urn:bindingTemplate bindingKey='' serviceKey='#{urn}#{service}'><description>#{description}</description><accessPoint URLType='#{url_type}'>#{binding}</accessPoint><urn:tModelInstanceDetails></urn:tModelInstanceDetails></urn:bindingTemplate>"
          end
        end
        request_soap('publishv2', 'save_binding', body) do | res|
          res.body
        end
      end

      def find_element_bindings(name, urn)
        request_soap('inquiryv2', 'get_serviceDetail', "<urn:serviceKey>#{urn}#{name}</urn:serviceKey>") do |res|
          extract_bindings(res.body)
        end
      end

      def delete_binding(binding)
        authorize
        request_soap('publishv2', 'delete_binding', "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:bindingKey>#{binding}</urn:bindingKey>") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def get_service_element(name, urn)
        key = name.include?(urn) ? name : "#{urn}#{name}"
        request_soap('inquiryv2', 'get_serviceDetail', "<urn:serviceKey>#{key}</urn:serviceKey>") do |res|
          { 'name' => extract_name(res.body),
            'description' => extract_descriptions(res.body),
            'definition' => extract_service_definition(res.body) }
        end
      end

      def save_service_element(name, description, definition, urn, business_key = @urns['company'])
        authorize
        body = "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessService businessKey='#{business_key}' serviceKey='#{urn}#{name}'><urn:name xml:lang='en'>#{name}</urn:name>"
        if description
          description.each do |desc|
            body = body + "<urn:description xml:lang='en'>#{desc}</urn:description>" if desc and not (desc == "")
          end
        end
        body = body + "<urn:categoryBag><urn:keyedReference tModelKey='uddi:uddi.org:wadl:types' keyName='service-definition' keyValue='#{definition}'></urn:keyedReference></urn:categoryBag>" if definition and not (definition.strip == "")
        body = body + "</urn:businessService>"

        request_soap('publishv2', 'save_service', body) do | res|
          extract_service(res.body)
        end
      end

      def delete_service_element(name, urn)
        authorize
        request_soap('publishv2', 'delete_service', "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:serviceKey>#{urn}#{name}</urn:serviceKey>") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def extract_service(soap)
        entries = {}
        entries[extract_service_id(soap)] = extract_name(soap)
        entries
      end

      def extract_service_entries_elements(soap, urn)
        entries = {}
        entry = soap[/<ns2:serviceInfos>(.*?)<\/ns2:serviceInfos>/, 1]
        while entry do
          service = entry[/<ns2:serviceInfo (.*?)<\/ns2:serviceInfo>/, 1]
          break if service.nil?
          id = extract_service_id(service)
          entries[id.gsub(urn, "")] = { 'id' => id, 'name' => extract_name(service) } if id.include?(urn)
          entry[/<ns2:serviceInfo (.*?)<\/ns2:serviceInfo>/, 1] = ""
          entry.gsub!("<ns2:serviceInfo </ns2:serviceInfo>", "")
          entry = nil if entry.strip == ""
        end
        { 'services' => entries }
      end

      def extract_service_id(soap)
        soap[/serviceKey="(.*?)"/, 1]
      end

      def extract_service_definition(soap)
        soap[/<ns2:keyedReference tModelKey="uddi:uddi.org:wadl:types" keyName="service-definition" keyValue="(.*?)"\/>/, 1]
      end

      def extract_business(soap)
        entries = {}
        entries[extract_business_id(soap).gsub(@urns['domains'], "")] = { 'name' => extract_name(soap), 'description' => extract_descriptions(soap) }
        entries
      end

      def extract_business_entries(soap)
        entries = {}
        entry = soap[/<ns2:businessList (.*?)<\/ns2:businessList>/, 1]
        while entry do
          business = entry[/<ns2:businessInfo (.*?)<\/ns2:businessInfo>/, 1]
          break if business.nil?
          business[/<ns2:serviceInfos(.*?)<\/ns2:serviceInfos>/, 1] = "" if business[/<ns2:serviceInfos(.*?)<\/ns2:serviceInfos>/, 1]
          id = extract_business_id(entry)
          entries[id.gsub(@urns['domains'], "")] = { 'id' => id, 'name' => extract_name(business) }
          entry[/<ns2:businessInfo (.*?)<\/ns2:businessInfo>/, 1] = ""
          entry.gsub!("<ns2:businessInfo </ns2:businessInfo>", "")
          entry = nil if entry.strip == ""
        end
        { 'businesses' => entries }
      end

      def extract_business_id(soap)
        soap[/businessKey="(.*?)"/, 1]
      end

      def extract_bindings(soap)
        entries = {}
        entry = soap[/<ns2:bindingTemplates>(.*?)<\/ns2:bindingTemplates>/, 1]
        while entry do
          binding = entry[/<ns2:bindingTemplate (.*?)<\/ns2:bindingTemplate>/, 1]
          break if binding.nil?
          id = extract_binding_id(binding)
          entries[id] = {'access_point' => extract_access_point(binding), 'description' => extract_description(binding)}
          entry[/<ns2:bindingTemplate (.*?)<\/ns2:bindingTemplate>/, 1] = ""
          entry.gsub!("<ns2:bindingTemplate </ns2:bindingTemplate>", "")
          entry = nil if entry.strip == ""
        end
        { 'bindings' => entries }
      end

      def extract_binding_id(soap)
        soap[/bindingKey="(.*?)">/, 1]
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

      def extract_errno(soap)
        soap[/<ns2:result errno="(.*?)"\/>/, 1]
      end

      def soap_envelope(message, urn = nil, attr = nil)
        body = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:uddi-org:api_v2'> <soapenv:Header/> <soapenv:Body> "
        body = body + "<urn:#{urn} generic='2.0' xmlns='urn:uddi-org:api_v2' " + (attr.nil? ? "" : attr) + ">" if urn
        body = body + message
        body = body + "</urn:#{urn}>" if urn
        body = body + "</soapenv:Body> </soapenv:Envelope>"
        body
      end

      def connection(service, action)
        @uri = URI("#{@base_uri}/juddiv3/services/#{service}")
        req = Net::HTTP::Post.new(@uri)
        req.content_type = 'text/xml;charset=UTF-8'
        req['SOAPAction'] = action
        req
      end
        
      def execute(req, &block)
        res = Net::HTTP.start(@uri.hostname, @uri.port) do |http|
          http.request(req)
        end

        case res
          when Net::HTTPSuccess
            result = block.call(res) if block
            return success_data(result) if result
            return success
          else
            return fail(res.body)
          end
      end

      def authorize
        @auth_token = '' # clear any existing token
        req = connection('security', 'get_authToken')
        req.body = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:uddi-org:api_v3'> <soapenv:Header/> <soapenv:Body> <urn:get_authToken userID='#{@auth_user}' cred='#{@auth_password}'/> </soapenv:Body> </soapenv:Envelope>"
        result = execute(req) do |res|
          @auth_token = (res.body.split('authtoken:')[1]).split('<')[0]
        end
      end

      def request_soap(version, service, request, attr = nil, &block)
        req = connection(version, service)
        req.body = soap_envelope(request, service, attr)
        execute(req) do |res|
          block.call(res)
        end
      end

      def check_availability
        result = `curl -S #{@base_uri}/juddiv3 2>&1`
        not(result.downcase.include?("fail"))
      end
    end
  end
end
