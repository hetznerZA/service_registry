module ServiceRegistry
  module Providers
  	class Soap4JUDDIXML
      def element_with_key_value(element, key, value, attributes = nil)
      	element_with_value(element, "#{key}:#{value}")
      end

  		def element_with_value(element, value, attributes = nil)
  			xml = "<urn:#{element}"
  			if attributes
  				attributes.each do |k, v|
  					v = "'#{v}'" if v.is_a?(String)
  				  xml = "#{xml} #{k}=#{v}"
  				end
  			end
  			xml = "#{xml}>#{value}</urn:#{element}>"
  		end  	
  		
      def extract_id(soap, type)
        soap[/#{type}="(.*?)"/, 1]
      end

      def envelope_header_body(text, version = 3)
        "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:uddi-org:api_v#{version}'> <soapenv:Header/> <soapenv:Body> #{text} </soapenv:Body> </soapenv:Envelope>"      
      end  			
  	end
  end
end
