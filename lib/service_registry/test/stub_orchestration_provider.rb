module ServiceRegistry
  module Test
    class StubOrchestrationProvider < OrchestrationProvider
      alias :parent_setup :setup

      attr_accessor :iut, :domain_perspective, :service_component, :uri, :service_definition
      attr_reader :secure_service, :query, :configuration_bootstrap, :need, :services_found
      def setup
        parent_setup()

        @valid_uri = 'http://127.0.0.1'
        @configuration_service = ServiceRegistry::Test::StubConfigurationService.new
        @valid_service = { 'id' => 'valid_service_id_1', 'description' => 'valid service A', 'definition' => nil }
        @service_2 = { 'id' => 'valid_service_id_2', 'description' => 'valid service B', 'definition' => nil }
        @service_3 = { 'id' => 'entropy_service_id_3', 'description' => 'entropy service C', 'definition' => nil }
        @service_4 = { 'id' => 'service_id_4', 'description' => 'entropy service D', 'definition' => nil }
        @service_5 = { 'id' => 'service_id_5', 'description' => 'service E', 'definition' => nil }
        @secure_service = { 'id' => 'secure_service', 'description' => 'secure service B' }
        @domain_perspective_associations = []
        @service_component_domain_perspective_associations = []
        @domain_perspective_1 = 'domain_perspective_1'
        @domain_perspective_2 = 'domain_perspective_2'
        @domain_perspective = nil
        @service_component = nil
        @uri = nil
        @service_component_1 = 'sc1.dev.auto-h.net'
        @service_component_2 = 'sc2.dev.auto-h.net'
        @service_definition = nil
        @service_definition_1 = "<?xml version='1.0' encoding='UTF-8'?><?xml-stylesheet type='text/xsl' href='/wadl/wadl.xsl'?><wadl:application xmlns:wadl='http://wadl.dev.java.net/2009/02'    xmlns:jr='http://jasperreports.sourceforge.net/xsd/jasperreport.xsd'    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://wadl.dev.java.net/2009/02 wadl.xsd '><wadl:resources base='/'><wadl:resource path='/available-policies'>  <wadl:method name='GET' id='_available-policies'>    <wadl:doc>      Lists the policies available against which this service can validate credentials    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/validate-credential-using-policy'>  <wadl:method name='POST' id='_validate-credential-using-policy'>    <wadl:doc>      Given a credential string, examine the entropy against a security paradigm    </wadl:doc>    <wadl:request>      <wadl:param name='credential' type='xsd:string' required='true' style='query'>      </wadl:param>      <wadl:param name='policy' type='xsd:string' required='true' style='query'>      </wadl:param>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/generate-credential'>  <wadl:method name='GET' id='_generate-credential'>    <wadl:doc>      Generates a strong credential given a policy to adhere to    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/status'>  <wadl:method name='GET' id='_status'>    <wadl:doc>      Returns 100 if capable of validating credentials against a policy and returns 0 if policy dependencies have failed and unable to validate credentials against policies    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/status-detail'>  <wadl:method name='GET' id='_status-detail'>    <wadl:doc>      This endpoint provides detail of the status measure available on the /status endpoint    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource><wadl:resource path='/lexicon'>  <wadl:method name='GET' id='_lexicon'>    <wadl:doc>      Description of all the services available on this service component    </wadl:doc>    <wadl:request>    </wadl:request>  </wadl:method></wadl:resource></wadl:resources></wadl:application>"
      end

      def given_no_configuration_service_bootstrap
        @configuration_bootstrap = {}
      end

      def given_invalid_configuration_service_bootstrap
        @configuration_bootstrap = nil
      end

      def given_no_identifier_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd'}
      end

      def given_invalid_identifier_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => ' '}
      end

      def given_configuration_service_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => 'identifier' }
      end

      def given_configuration_service_inaccessible
        @configuration_service.break
      end

      def given_no_configuration_in_configuration_service
        @configuration_service.clear_configuration
      end

      def given_invalid_configuration_in_configuration_service
        @configuration_service.clear_configuration
        @configuration_service.configure({})
      end

      def given_valid_configuration_in_configuration_service
        @configuration_service.configure(@configuration_bootstrap)
      end

      def given_valid_identifier_bootstrap
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => 'identifier' }
        @configuration_service.configure(@configuration_bootstrap)
      end

      def initialize_service_registry
        process_result(@iut.bootstrap(@configuration_bootstrap, @configuration_service))
      end

      def has_received_notification?(message)
        @notifications.each do |notification|
          return true if notification == message
        end
        false
      end

      def service_registry_available?
        process_result(@iut.available?)
        success? and (data['available'] == true)
      end

      def define_one_domain_perspective
        process_result(@iut.delete_all_domain_perspectives)
        process_result(@iut.register_domain_perspective(@domain_perspective_1))
      end

      def define_multiple_domain_perspectives
        process_result(@iut.delete_all_domain_perspectives)
        process_result(@iut.register_domain_perspective(@domain_perspective_1))
        process_result(@iut.register_domain_perspective(@domain_perspective_2))
      end

      def list_domain_perspectives
        process_result(@iut.list_domain_perspectives)
      end

      def list_service_components
        process_result(@iut.list_service_components(@domain_perspective))
      end

      def given_service_components_exist
        process_result(@iut.delete_all_service_components)
        process_result(@iut.register_service_component(@service_component_1))
        process_result(@iut.register_service_component(@service_component_2))
      end

      def given_service_components_exist_in_the_domain_perspective
        process_result(@iut.delete_all_service_components)
        process_result(@iut.register_service_component(@service_component_1))
        process_result(@iut.register_service_component(@service_component_2))
        process_result(@iut.associate_service_component_with_domain_perspective(@domain_perspective, @service_component_1))
      end

      def given_no_service_components_exist
        process_result(@iut.delete_all_service_components)
      end

      def given_no_service_components_exist_in_domain_perspective
        process_result(@iut.delete_all_service_components)
      end

      def received_list_of_all_service_components?
        success? and data['service_components'].include?(@service_component_1) and data['service_components'].include?(@service_component_2)
      end

      def received_list_of_all_service_components_in_domain_perspective?
        success? and (data['service_components'].include?(@service_component_1)) and (data['service_components'].size == 1)
      end

      def received_one_domain_perspective?
        success? and (data['domain_perspectives'].size == 1) and (data['domain_perspectives'].include?(@domain_perspective_1))
      end

      def received_no_services?
        success? and (data['services'] == [])
      end

      def received_empty_list_of_service_components?
        success? and (data['service_components'] == [])
      end

      def received_multiple_domain_perspectives?
        success? and (data['domain_perspectives'].size == 2) and (data['domain_perspectives'].include?(@domain_perspective_1)) and (data['domain_perspectives'].include?(@domain_perspective_2))
      end

      def received_an_empty_list_of_domain_perspectives?
        success? and (data['domain_perspectives'] == [])
      end

      def clear_all_domain_perspectives
        @iut.delete_all_domain_perspectives
      end

      def break_registry
        @iut.break
      end

      def given_no_domain_perspective
        @domain_perspective = nil
      end

      def given_no_service
        @service = nil
      end

      def register_domain_perspective
        process_result(@iut.register_domain_perspective(@domain_perspective))
      end

      def register_service
        process_result(@iut.register_service(@service))
      end

      def deregister_service
        process_result(@iut.deregister_service(@service.is_a?(Hash) ? @service['id'] : @service))
      end

      def register_service_component
        process_result(@iut.register_service_component(@service_component))
      end

      def is_domain_perspective_available?
        @iut.fix
        process_result(@iut.list_domain_perspectives)
        success? and data['domain_perspectives'].include?(@domain_perspective)
      end

      def is_service_component_available?
        @iut.fix
        process_result(@iut.list_service_components)
        success? and data['service_components'].include?(@service_component)
      end

      def given_a_new_domain_perspective
        @iut.delete_all_domain_perspectives
        @domain_perspective = @domain_perspective_1
      end

      def given_an_existing_domain_perspective
        define_one_domain_perspective
        @domain_perspective = @domain_perspective_1
      end

      def given_existing_service_component_identifier
        @iut.register_service_component(@service_component_1)
        @service_component = @service_component_1
      end

      def given_an_invalid_domain_perspective
        @domain_perspective = " "
      end

      def given_invalid_service_component_identifier
        @service_component = " "
      end

      def given_invalid_service
        @service = " "
      end

      def given_invalid_service_for_registration
        @service = { 'id' => "" }
      end

      def given_existing_service_identifier
        @service = @service_1['id']
      end

      def given_new_service
        @service = @service_2
      end

      def given_no_service_component_identifier
        @service_component = nil
      end

      def given_unknown_domain_perspective
        @domain_perspective = 'unknown'
      end

      def deregister_domain_perspective
        process_result(@iut.deregister_domain_perspective(@domain_perspective))
      end

      def given_no_service_components_associated_with_domain_perspective
        @iut.delete_domain_perspective_service_component_associations(@domain_perspective)
      end

      def given_service_components_associated_with_domain_perspective
        @iut.associate_service_component_with_domain_perspective(@domain_perspective, @service_component_1)
      end

      def given_new_service_component_identifier
        @service_component = @service_component_1
      end

      def given_unknown_service_component
        @service_component = 'unknown'
      end

      def deregister_service_component
        process_result(@iut.deregister_service_component(@service_component))
      end

      def given_no_services_associated_with_service_component
        process_result(@iut.deregister_all_services_for_service_component(@service_component))
      end

      def given_no_domain_perspectives_associated_with_service_component
        # do nothing, when the test starts none of these exist
      end

      def given_some_or_no_associations_of_service_components_with_domain_perspective
        @domain_perspective_associations = @iut.domain_perspective_associations(@domain_perspective)
      end

      def given_some_or_no_associations_of_domain_perspectives_with_service_component
        @service_component_domain_perspective_associations = @iut.service_component_domain_perspective_associations(@service_component)
      end

      def service_component_associations_changed?
        process_result(@iut.service_component_domain_perspective_associations(@service_component))
        not arrays_the_same?(data['associations'], @service_component_domain_perspective_associations)
      end

      def domain_perspective_associations_changed?
        process_result(@iut.domain_perspective_associations(@domain_perspective))
        not arrays_the_same?(data['associations'], @domain_perspective_associations)
      end

      def associate_services_with_service_component
        process_result(@iut.associate_service_with_service_component(@service_component, @service_1['id']))
        process_result(@iut.associate_service_with_service_component(@service_component, @service_2['id']))
      end

      def associate_domain_perspective_with_service_component
        process_result(@iut.associate_service_component_with_domain_perspective(@domain_perspective, @service_component))
        perspective_associations = process_result(@iut.domain_perspective_associations(@domain_perspective))
        @domain_perspective_associations = data['associations']
      end

      def disassociate_domain_perspective_from_service_component
        process_result(@iut.disassociate_service_component_from_domain_perspective(@domain_perspective, @service_component))
        process_result(@iut.domain_perspective_associations(@domain_perspective))
        @domain_perspective_associations = data['associations']
      end

      def is_service_component_associated_with_domain_perspective?
        process_result(@iut.service_component_domain_perspective_associations(@service_component))
        data['associations'].include?(@domain_perspective)
      end

      def is_service_component_associated_with_service?
        process_result(@iut.does_service_component_have_service_associated?(@service_component, @service))
        data['associated']
      end

      def associate_service_with_service_component
        process_result(@iut.associate_service_component_with_service(@service, @service_component))
      end

      def associate_service_with_two_service_components
        process_result(@iut.associate_service_component_with_service(@service, @service_component_1))
        process_result(@iut.associate_service_component_with_service(@service, @service_component_2))
      end

      def disassociate_service_from_service_component
        process_result(@iut.disassociate_service_component_from_service(@service, @service_component))
      end

      def given_a_valid_service
        @service = @valid_service['id']
        @iut.register_service(@valid_service)
        result = @iut.service_definition_for_service(@service)
        @pre_service_definition = result['status'] == 'fail' ? nil : result['data']['definition']
      end

      def service_definition_changed?
        result = @iut.service_definition_for_service(@service.is_a?(Hash) ? @service['id'] : @service)
        @current_definition = result['status'] == 'fail' ? nil : result['data']['definition']
        not (@current_definition == @pre_service_definition)
      end

      def given_unknown_service
        @service = "unknown"
      end

      def given_no_URI
        @uri = nil
      end

      def given_valid_URI
        @uri = @valid_uri
      end

      def given_invalid_URI
        @uri = 'http:// 127.0.0.1'
      end

      def configure_service_component_with_URI
        process_result(@iut.configure_service_component_uri(@service_component, @uri))
        @pre_uri = @uri if success?
      end

      def is_service_component_configured_with_URI?
        process_result(@iut.service_component_uri(@service_component))
        data['uri'] == @uri
      end

      def service_component_uri_changed?
        process_result(@iut.service_component_uri(@service_component))
        @uri = data['uri']
        @uri != @pre_uri
      end

      def given_a_valid_service_definition
        @service_definition = @service_definition_1
      end

      def register_service_definition
        process_result(@iut.register_service_definition(@service.is_a?(Hash) ? @service['id'] : @service, @service_definition))
      end

      def deregister_service_definition
        process_result(@iut.deregister_service_definition(@service.is_a?(Hash) ? @service['id'] : @service))
      end

      def service_available?
        id = @service.nil? ? "" : @service['id']
        process_result(@iut.service_registered?(id))
        data['registered']
      end

      def is_service_described_by_service_definition?
        process_result(@iut.service_definition_for_service(@service.is_a?(Hash) ? @service['id'] : @service))
        data['definition'] == @service_definition
      end

      def given_invalid_service_definition
        @service_definition = "blah"
      end

      def given_no_service_definition
        @service_definition = nil
      end

      def request_service_definition
        process_result(@iut.service_definition_for_service(@service.is_a?(Hash) ? @service['id'] : @service))
      end

      def has_received_service_definition?
        data['definition'] == @service_definition_1
      end

      def given_a_need
        @need = 'valid'
      end

      def given_a_pattern
        @need = 'entropy'
      end

      def no_services_match_need
        @need = 'no services match this'
      end

      def match_need
        process_result(@iut.search_for_service(@need))
      end

      def services_found?
        not data['services'].empty?
      end

      def provide_one_matching_service
        @service = @service_1['id']
        @iut.register_service(@service_1)
        @iut.register_service_definition(@service_1['id'], @service_definition_1)
      end

      def provide_two_matching_services
        @iut.register_service(@service_1)
        @iut.register_service(@service_2)
        @iut.register_service_definition(@service_1['id'], @service_definition_1)
        @iut.register_service_definition(@service_2['id'], @service_definition_1)
      end

      def single_service_match?
        (data['services'].count == 1) and (data['services'].first['id'] == @service_1['id'])
      end

      def multiple_services_match?
        (data['services'].count == 2) and ((data['services'][0]['id'] == @service_1['id']) or (data['services'][0]['id'] == @service_2['id'])) and ((data['services'][1]['id'] == @service_1['id']) or (data['services'][1]['id'] == @service_2['id']))
      end

      def entry_matches?
        data['services'].first['id'].include?(@need) == true
      end

      def both_entries_match?
        data['services'][0]['id'].include?(@need) == true
        data['services'][1]['id'].include?(@need) == true
      end

      def service_by_id
        process_result(@iut.service_by_id(@service))
      end

      def given_service_with_pattern_in_id
        @expected_pattern_service = @service_3
        @iut.register_service(@service_3)
        @iut.register_service_definition(@service_3['id'], @service_definition_1)
      end

      def given_service_with_pattern_in_description
        @expected_pattern_service = @service_4
        @iut.register_service(@service_4)
        @iut.register_service_definition(@service_4['id'], @service_definition_1)
      end

      def multiple_existing_services
        @iut.register_service(@service_1)
        @iut.register_service(@service_4)
        @expected_pattern_service = @service_4
        @iut.register_service_definition(@service_4['id'], @service_definition_1)
      end

      def multiple_existing_service_components
        @iut.register_service_component(@service_component_1)
        @iut.register_service_component(@service_component_2)
        @iut.associate_service_component_with_service(@service_4['id'], @service_component_2)
        @iut.associate_service_component_with_service(@service_1['id'], @service_component_1)
      end

      def multiple_existing_domain_perspectives
        @iut.register_domain_perspective(@domain_perspective_1)
        @iut.register_domain_perspective(@domain_perspective_2)
      end

      def service_components_registered_in_different_domain_perspectives
        @iut.associate_service_component_with_domain_perspective(@domain_perspective_2, @service_component_1)
        @iut.associate_service_component_with_domain_perspective(@domain_perspective_1, @service_component_2)
      end

      def given_service_with_pattern_in_definition
        @expected_pattern_service = @service_5
        @iut.register_service(@service_5)
        @iut.register_service_definition(@service_5['id'], @service_definition_1)
      end

      def service_matched_pattern?
        (data['services'].count == 1) and (data['services'].first['id'] == @expected_pattern_service['id'])
      end

      def match_pattern_in_domain_perspective
        process_result(@iut.search_domain_perspective(@domain_perspective_1, @need))
      end

      def matched_pattern_in_domain_perspectice?
        data['services'].size == 1
      end

      def matched_only_in_domain_perspective?
        data['services'][0] == @service_4
      end

      def has_list_of_service_components_providing_service?
        data['services'][0]['service_components'].count > 0
      end

      def has_list_of_both_service_components_providing_service?
        scs = data['services'][0]['service_components']
        (scs.count > 0) and (not scs[@service_component_1].nil?) and (not scs[@service_component_2].nil?)
      end

      def has_uri_to_service_component_providing_service?
        sc = data['services'][0]['service_components'][@service_component]
        sc['uri'] == @valid_uri
      end

      def has_status_of_service_component_providing_service?
        sc = data['services'][0]['service_components'][@service_component]
        sc['status'] == '100'
      end

      def no_service_definition_associated
        # By default no service definition associated
      end

      def service_definitions
        process_result(@iut.service_definitions(service_component))
      end
    end
  end
end

ServiceRegistry::Test::OrchestrationProviderRegistry.instance.register("stub", "*", ServiceRegistry::Test::StubOrchestrationProvider)
