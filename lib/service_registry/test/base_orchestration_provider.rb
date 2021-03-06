module ServiceRegistry
  module Test
    class BaseOrchestrationProvider
      def setup
        @notifications = []
        @domain_perspective = nil
        @service = nil
        @domain_perspective_associations = []
        @service_component_domain_perspective_associations = []

        @team = 'teamA'
        @standardized_team = 'teama'
        @domain_perspective_1 = 'domain_perspective_1'
        @domain_perspective_2 = 'domain_perspective_2'
        @valid_uri = 'http://127.0.0.1'
        @configuration_service = ServiceRegistry::Test::StubConfigurationService.new
        @valid_service = { 'name' => 'valid_service_id_1', 'description' => 'valid service A', 'definition' => nil }
        @service_1 = { 'name' => 'valid_service_id_1', 'description' => 'valid service A', 'definition' => nil }
        @service_2 = { 'name' => 'valid_service_id_2', 'description' => 'valid service B', 'definition' => nil }
        @service_3 = { 'name' => 'entropy_service_id_3', 'description' => 'entropy service C', 'definition' => nil }
        @service_4 = { 'name' => 'service_id_4', 'description' => 'entropy service D', 'definition' => nil }
        @service_5 = { 'name' => 'service_id_5', 'description' => 'service E', 'definition' => nil }
        @service_uppercase = { 'name' => 'VALID_SERVICE_ID_2', 'description' => 'valid service B', 'definition' => nil }
        @secure_service = { 'name' => 'secure_service', 'description' => 'secure service B' }
        @service_component = nil
        @uri = nil
        @service_component_1 = 'sc1.dev.auto-h.net'
        @service_component_2 = 'sc2.dev.auto-h.net'
        @service_definition = nil
        @service_uri_pattern = 'localhost'
        @service_uri_1 = 'http://localhost/1'
        @service_uri_2 = 'http://localhost/2'
        @contact_1 = { 'name' => 'Darren Silke', 'email' => 'darren@smooth-silk.com', 'description' => 'Intern', 'phone' => '0217881445'}; @contact_1.freeze
        @contact_2 = { 'name' => 'Tenashe Madzingaidzo', 'email' => 'tenashe@greatpasswords.net', 'phone' => '', 'description' => ''}; @contact_2.freeze

        #@service_definition_1 = "<?xml version='1.0' encoding='UTF-8'?><?xml-stylesheet type='text/xsl' href='/wadl/wadl.xsl'?><wadl:application xmlns:wadl='http://wadl.dev.java.net/2009/02'    xmlns:jr='http://jasperreports.sourceforge.net/xsd/jasperreport.xsd'    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://wadl.dev.java.net/2009/02 wadl.xsd '><wadl:resources base='/'><wadl:resource path='/available-policies'>  <wadl:method name='GET' id='_available-policies'>    <wadl:doc>      Lists the policies available against which this service can validate credentials    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/validate-credential-using-policy'>  <wadl:method name='POST' id='_validate-credential-using-policy'>    <wadl:doc>      Given a credential string, examine the entropy against a security paradigm    </wadl:doc>    <wadl:request>      <wadl:param name='credential' type='xsd:string' required='true' style='query'>      </wadl:param>      <wadl:param name='policy' type='xsd:string' required='true' style='query'>      </wadl:param>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/generate-credential'>  <wadl:method name='GET' id='_generate-credential'>    <wadl:doc>      Generates a strong credential given a policy to adhere to    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/status'>  <wadl:method name='GET' id='_status'>    <wadl:doc>      Returns 100 if capable of validating credentials against a policy and returns 0 if policy dependencies have failed and unable to validate credentials against policies    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/status-detail'>  <wadl:method name='GET' id='_status-detail'>    <wadl:doc>      This endpoint provides detail of the status measure available on the /status endpoint    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/lexicon'>  <wadl:method name='GET' id='_lexicon'>    <wadl:doc>      Description of all the services available on this service component    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource></wadl:resources></wadl:application>"
        @service_definition_1 = "https://github.com/hetznerZA/some/service/wadl/definition.xml"
        @valid_meta = {'dss' => 'http://my.dss.host-h.net/qid=should_this_service_be_included&service=SERVICE-ID'}
        @original_meta = { 'valid' => 'meta' }
      end

      def inject_iut(iut)
        @iut = iut
      end

      def given_a_registered_service
        @service = @service_1
        process_result(@iut.register_service(@service))
      end

      def select_service
        @query = 'secure service'
      end

      def query_a_service
        process_result(@iut.query_service_by_pattern(@query))
      end

      def service_included_in_results?
        success? and not (data['services'][@service['name']]).nil?
      end

      def given_a_new_domain_perspective
        @iut.reset_domain_perspectives
        @domain_perspective = @domain_perspective_1
      end

      def given_a_new_team
        @iut.reset_domain_perspectives
      end

      def given_no_domain_perspective
        @domain_perspective = nil
      end

      def given_unknown_domain_perspective
        @domain_perspective = "unknown"
      end

      def given_an_invalid_domain_perspective
        @domain_perspective = " "
      end      

      def given_an_existing_domain_perspective
        #byebug
        process_result(@iut.reset_domain_perspectives)
        process_result(@iut.register_domain_perspective(@domain_perspective_1))
        @domain_perspective = @domain_perspective_1
      end

      def given_existing_service_component_identifier
        @iut.register_service_component(@service_component_1)
        process_result(@iut.service_component_uri(@service_component_1))
        @pre_uri = data['uri']
        @service_component = @service_component_1
      end

      def configure_service_component_with_URI
        process_result(@iut.configure_service_component_uri(@service_component, @uri))
        @pre_uri = @uri if success?
      end

      def given_no_URI
        @uri = nil
      end

      def given_valid_URI
        @uri = @service_uri_1
      end

      def given_valid_URI_pattern
        @uri = @service_uri_pattern
      end

      def given_invalid_URI
        @uri = 'http:// 127.0.0.1'
      end

      def given_invalid_service_component_identifier
        @service_component = " "
      end

      def given_unknown_service_component_identifier
        @service_component = "unknown"
      end

      def given_no_service_component_identifier
        @service_component = nil
      end

      def given_new_service_component_identifier
        @iut.delete_all_service_components
        @service_component = @service_component_1
      end

      def given_unknown_service_component
        @service_component = 'unknown'
      end

      def given_unknown_service
        @service = "unknown"
      end

      def given_invalid_service
        @service = " "
      end

      def given_no_service
        @service = nil
      end

      def associate_domain_perspective_with_service_component
        process_result(@iut.associate_service_component_with_domain_perspective(@service_component, @domain_perspective))
        process_result(@iut.domain_perspective_associations(@domain_perspective))
        @domain_perspective_associations = data['associations']
      end

      def associate_domain_perspective_with_service
        process_result(@iut.associate_service_with_domain_perspective(service_name, @domain_perspective))
        process_result(@iut.domain_perspective_associations(@domain_perspective))
        @domain_perspective_associations = data['associations']
      end

      def register_service_definition
        process_result(@iut.register_service_definition(service_name, @service_definition))
      end

      def associate_service_with_two_service_components
        process_result(@iut.associate_service_component_with_service(@service, @service_uri_1))
        process_result(@iut.associate_service_component_with_service(@service, @service_uri_2))
      end

      def associate_service_with_service_component
        process_result(@iut.associate_service_component_with_service(@service, @service_uri_1))
      end

      def delete_all_domain_perspective_associations
        @iut.delete_all_domain_perspective_associations(@domain_perspective)
      end      

      def given_a_valid_service
        @service = @valid_service['name']
        @iut.register_service(@valid_service)
        result = @iut.service_definition_for_service(@service)
        @pre_service_definition = result['status'] == 'fail' ? nil : result['data']['definition']
      end

      def given_valid_contact_details
        @contact = @contact_1
      end

      def given_no_contact_details
        @contact = nil
      end

      def given_invalid_contact_details
        @contact = {}
      end

      def given_existing_contact
        result = @iut.contact_details_for_domain_perspective(@domain_perspective)
        result['data']['contacts'].each do |contact|
          remove_contact_from_domain_perspective(@domain_perspective, contact)
        end
        @contact = @contact_1
        @iut.add_contact_to_domain_perspective(@domain_perspective, @contact)
      end      

      def break_registry
        @accept_failure_notifications_in_production = true if ENV['TEST_ORCHESTRATION_PROVIDER'] == 'production'
        @iut.break
      end

      def process_result(result)
        @result = result

        @notifications.push(@result['data']['notifications']) if @result and @result.is_a?(Hash) and @result['data'] and @result['data'].is_a?(Hash) and @result['data']['notifications']
        @notifications << @result if @result and not @result.is_a?(Hash)
        @notifications.flatten!
      end

      def success?
        (not @result.nil?) and (not @result['status'].nil?) and (@result['status'] == 'success')
      end

      def data
        @result['data']
      end

      def arrays_the_same?(a, b)
        c = a - b
        d = b - a
        (c.empty? and d.empty?)
      end

      def has_received_notification?(message)
        if @accept_failure_notifications_in_production
          @accept_failure_notifications_in_production = false
          return true
        end
        @notifications.each do |notification|
          #puts "COMPARING #{notification} with #{message}"
          return true if notification == message
        end
        false
      end

      def unauthorized
        @iut.authorized = false
      end

      def configure_some_service_uris
        @iut.add_service_uri(service_name, @service_uri_1)
        @pre_uris = extract_service_uris
      end

      def extract_service_uris
        process_result(@iut.service_uris(service_name))
        uris = []
        data['bindings'].each do |binding, detail|
          uris << detail['access_point']
        end
        uris
      end

      def service_name
        @service.is_a?(Hash) ? @service['name'] : @service
      end      
    end
  end
end
