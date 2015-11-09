require 'net/http'
require 'byebug'

module ServiceRegistry
  module Providers
    class JUDDIProvider < JSendProvider
      def initialize(base_urn, company_urn, domain_urn, services_urn)
        @auth_user = ''
        @auth_password = ''
        @base_urn = base_urn
        @company_urn = company_urn
        @domain_urn = domain_urn
        @services_urn = services_urn
      end

      def set_uri(uri)
        @base_uri = uri
      end

      def authenticate(auth_user, auth_password)
        @auth_user = auth_user
        @auth_password =auth_password
      end

      def save_bindings(service, bindings)
        authorize
        body = "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo>"
        if (not bindings.nil?) and (not (bindings.size == 0))
          bindings.each do |binding|
            url_type = nil
            url_type = 'https' if binding.include?('https')
            url_type = 'http' if (not binding.include?('https') and binding.include?('http'))
            url_type ||= 'unknown'
            body = body + "<urn:bindingTemplate bindingKey='' serviceKey='#{@services_urn}:#{service}'><accessPoint URLType='#{url_type}'>#{binding}</accessPoint><urn:tModelInstanceDetails></urn:tModelInstanceDetails></urn:bindingTemplate>"
          end
        end
        request_soap('publishv2', 'save_binding', body) do | res|
          extract_bindings(res.body)
        end
      end

      def find_bindings(name)
        request_soap('inquiryv2', 'get_serviceDetail', "<urn:serviceKey>#{@services_urn}:#{name}</urn:serviceKey>") do |res|
          extract_bindings(res.body)
        end
      end

      def delete_binding(binding)
        authorize
        request_soap('publishv2', 'delete_binding', "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:bindingKey>#{binding}</urn:bindingKey>") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def get_service(name)
        request_soap('inquiryv2', 'get_serviceDetail', "<urn:serviceKey>#{@services_urn}:#{name}</urn:serviceKey>") do |res|
          { 'name' => extract_name(res.body),
            'description' => extract_description(res.body),
            'definition' => extract_service_definition(res.body) }
        end
      end

      def save_service(name, description = nil, definition = nil)
        authorize
        body = "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessService businessKey='#{@company_urn}' serviceKey='#{@services_urn}:#{name}'><urn:name xml:lang='en'>#{name}</urn:name>"
        body = body + "<urn:description xml:lang='en'>#{description}</urn:description>" if description and not (description == "")
        body = body + "<urn:categoryBag><urn:keyedReference tModelKey='uddi:uddi.org:wadl:types' keyName='service-definition' keyValue='#{definition}'></urn:keyedReference></urn:categoryBag>" if definition and not (definition.strip == "")
        body = body + "</urn:businessService>"

        request_soap('publishv2', 'save_service', body) do | res|
          extract_service(res.body)
        end
      end

      def find_services(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"

        request_soap('inquiryv2', 'find_service',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier> <findQualifier>orAllKeys</findQualifier> </findQualifiers> <name>#{pattern}</name>") do |res|
          extract_service_entries(res.body)
        end
      end

      def delete_service(name)
        authorize
        request_soap('publishv2', 'delete_service', "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:serviceKey>#{@services_urn}:#{name}</urn:serviceKey>") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def service_eq?(service, comparison)
        service == "#{@services_urn}:#{comparison}"
      end

      def available?
        { 'available' => check_availability }
      end

      # pull up into the tfa
      #def delete_all_domain_perspectives
      #  businesses = list_domain_perspectives
      #  businesses.each do |id, name|
      #    delete_business(id)
      #  end
      #end  

      def save_business(name)
        authorize
        request_soap('publishv2', 'save_business',
                     "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessEntity businessKey='#{@domain_urn}#{name}'><name>#{name}</name></urn:businessEntity>") do | res|
          extract_service(res.body)
        end
      end

      def find_businesses(pattern = nil)
        pattern = pattern.nil? ? '%' : "%#{pattern}%"
        request_soap('inquiryv2', 'find_business',
        "<findQualifiers> <findQualifier>approximateMatch</findQualifier></findQualifiers> <name>#{pattern}</name>") do |res|
          extract_business_entries(res.body)
        end
      end

      def delete_business(id)
        authorize
        request_soap('publishv2', 'delete_business',
        "<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessKey>#{id}</urn:businessKey>") do |res|
          { 'errno' => extract_errno(res.body) }
        end
      end

      def business_eq?(business, comparison)
        business == "#{@domain_urn}#{comparison}"
      end    

    private
      def extract_service(soap)
        entries = {}
        entries[extract_service_id(soap)] = extract_name(soap)
        entries
      end

      def extract_service_entries(soap)
        entries = {}
        entry = soap[/<ns2:serviceInfos>(.*?)<\/ns2:serviceInfos>/, entries.size + 1]

        while entry do
          entries[extract_service_id(entry)] = extract_name(entry)
          entry = soap[/<ns2:serviceInfos>(.*?)<\/ns2:serviceInfos>/, entries.size + 1]
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
        entries[extract_business_id(soap)] = extract_name(soap)
        entries
      end

      def extract_business_entries(soap)
        entries = {}
        entry = soap[/<ns2:businessInfo (.*?)<\/ns2:businessInfo>/, 1]

        while entry do
          # only include Hetzner entries
          entries[extract_business_id(entry)] = extract_name(entry) if extract_business_id(entry).include?('hetzner')
          # this trickery here is required as the regex match gets in trouble
          soap[/<ns2:businessInfo (.*?)<\/ns2:businessInfo>/, 1] = ""
          soap.gsub!("<ns2:businessInfo </ns2:businessInfo>", "")
          entry = soap[/<ns2:businessInfo (.*?)<\/ns2:businessInfo>/, 1]
        end
        { 'businesses' => entries }
      end

      def extract_business_id(soap)
        soap[/businessKey="(.*?)"/, 1]
      end

      def extract_bindings(soap)
        entries = {}
        entry = soap[/<ns2:bindingTemplate (.*?)<\/ns2:bindingTemplate>/, 1]

        while entry do
          # only include Hetzner entries
          entries[extract_binding_id(entry)] = extract_access_point(entry)
          # this trickery here is required as the regex match gets in trouble
          soap[/<ns2:bindingTemplate (.*?)<\/ns2:bindingTemplate>/, 1] = ""
          soap.gsub!("<ns2:bindingTemplate </ns2:bindingTemplate>", "")
          entry = soap[/<ns2:bindingTemplate (.*?)<\/ns2:bindingTemplate>/, 1]
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
