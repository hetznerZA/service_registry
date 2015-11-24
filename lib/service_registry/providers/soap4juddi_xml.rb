module ServiceRegistry
  module Providers
  	class Soap4JUDDIXML
      def element_with_key_value(element, key, value, attributes = nil)
      	element_with_value(element, "#{key}:#{value}")
      end

  		def element_with_value(element, value, attributes = nil)
  			xml = "<urn:#{element}"
  			xml = append_key_value_attributes_to_xml(xml, attributes) if attributes
  			xml = "#{xml}>#{value}</urn:#{element}>"
  		end  	
  		
      def extract_id(soap, type)
        soap[/#{type}="(.*?)"/, 1]
      end

      def envelope_header_body(text, version = 3)
        "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:uddi-org:api_v#{version}'> <soapenv:Header/> <soapenv:Body> #{text} </soapenv:Body> </soapenv:Envelope>"      
      end

      def soap_envelope(message, urn = nil, attr = nil)
        text = ""
        text = text + "<urn:#{urn} generic='2.0' xmlns='urn:uddi-org:api_v2' " + (attr.nil? ? "" : attr) + ">" if urn
        text = text + message
        text = text + "</urn:#{urn}>" if urn
        envelope_header_body(text, 2)
      end

      def content_type
      	'text/xml;charset=UTF-8'
      end

      private

      def append_key_value_attributes_to_xml(xml, attributes)
				attributes.each do |k, v|
					v = "'#{v}'" if v.is_a?(String)
				  xml = "#{xml} #{k}=#{v}"
				end
        xml
      end 			
  	end
  end
end
