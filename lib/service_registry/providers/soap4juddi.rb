module ServiceRegistry
  module Providers
  	class Soap4JUDDI
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
  	end
  end
end
