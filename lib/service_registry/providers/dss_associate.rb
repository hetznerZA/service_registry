module ServiceRegistry
  module Providers
    module DssAssociate
      def associate_dss(dss)
        error = 'no DSS provided' if dss.nil?
        error = 'invalid DSS provided' if not is_uri_safe?(dss)
        @dss = dss if not error
        { 'status' => (error ? 'fail' : 'success'), 'data' => {'notifications' => (error ? [error] : [])}}
      end

      def dss 
        error = 'no DSS configured' if @dss.nil?
        { 'status' => (error ? 'fail' : 'success'), 'data' => {'notifications' => (error ? [error] : []), 'dss' => @dss}}
      end  

      def is_uri_safe?(uri)
        (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
      end          
    end
  end
end


