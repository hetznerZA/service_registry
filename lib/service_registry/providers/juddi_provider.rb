require 'net/http'
require 'byebug'

module ServiceRegistry
  module Providers
    class JUDDIProvider < JSendProvider
      def register_service(name)
        authorize
        req = connection('publishv2', 'save_service')
        req.body = soap_envelope("<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:businessService businessKey='uddi:hetzner.co.za:hetzner' serviceKey='uddi:hetzner.co.za:services:#{name}'><urn:name xml:lang='en'>#{name}</urn:name><urn:description xml:lang='pt'>Service description</urn:description></urn:businessService>", 'save_service')
        execute(req) do |res|
          entry = res.body
          name = entry[/<ns2:name xml:lang="en">(.*?)<\/ns2:name>/, 1]
          id = entry[/serviceKey="(.*?)"/, 1]
          { id => name }
        end
      end

      def query_service_by_pattern(pattern)
        req = connection('inquiryv2', 'find_service')
        req.body = soap_envelope("<findQualifiers> <findQualifier>approximateMatch</findQualifier> <findQualifier>orAllKeys</findQualifier> </findQualifiers> <name>%#{pattern}%</name>", 'find_service')
        execute(req) do |res|
          entries = {}
          entry = res.body[/<ns2:serviceInfos>(.*?)<\/ns2:serviceInfos>/, entries.size + 1]

          while entry do
            name = entry[/<ns2:name xml:lang="en">(.*?)<\/ns2:name>/, 1]
            id = entry[/serviceKey="(.*?)"/, 1]

            entries[id] = name 
            entry = res.body[/<ns2:serviceInfos>(.*?)<\/ns2:serviceInfos>/, entries.size + 1]
          end
          { 'services' => entries }
        end
      end

      def deregister_service(id)
        authorize
        req = connection('publishv2', 'delete_service')
        req.body = soap_envelope("<urn:authInfo>authtoken:#{@auth_token}</urn:authInfo> <urn:serviceKey>#{id}</urn:serviceKey>", 'delete_service')
        execute(req) do |res|
          result = res.body[/<ns2:result errno="(.*?)"\/>/, 1]
          puts "success" if (not result.nil?) and (result == "0")
          result
        end
      end

      def available?
        if @available != false
          result = `curl -S http://localhost:8080/juddiv3 2>&1`
          @available = not(result.downcase.include?("fail"))
        end
        success_data('available' => @available)
      end

#    private
      def soap_envelope(message, urn = nil)
        body = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:uddi-org:api_v2'> <soapenv:Header/> <soapenv:Body> "
        body = body + "<urn:#{urn} generic='2.0' xmlns='urn:uddi-org:api_v2'>" if urn
        body = body + message
        body = body + "</urn:#{urn}>" if urn
        body = body + "</soapenv:Body> </soapenv:Envelope>"
        body
      end

      def connection(service, action)
        @uri = URI("http://localhost:8080/juddiv3/services/#{service}")
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
        req.body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:uddi-org:api_v3"> <soapenv:Header/> <soapenv:Body> <urn:get_authToken userID="root" cred="root"/> </soapenv:Body> </soapenv:Envelope>'
        result = execute(req) do |res|
          @auth_token = (res.body.split('authtoken:')[1]).split('<')[0]
        end
      end

    end
  end
end
