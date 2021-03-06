module ServiceRegistry
  module Test
    class BaseServiceOrchestrationProvider < BaseOrchestrationProvider
      def given_invalid_service_for_registration
        @service = { 'name' => "" }
      end

      def given_new_service
        @service = @service_2
        @iut.deregister_service(@service['name']) if @iut.service_registered?(@service['name'])
      end

      def given_new_service_uppercase
        @service = @service_uppercase
        @iut.deregister_service(@service['name']) if @iut.service_registered?(@service['name'])
      end

      def given_a_need
        @need = 'valid'
      end

      def given_a_pattern
        @need = 'id_3'
      end

      def given_no_pattern
        @need = nil
      end

      def given_invalid_pattern
        @need = 'my'
      end

      def given_invalid_URI_pattern
        @uri = 'meh'
      end

      def given_service_with_pattern_in_id
        @expected_pattern_service = @service_3
        @iut.register_service(@service_3)
        @iut.register_service_definition(@service_3['name'], @service_definition_1)
      end

      def given_service_with_pattern_in_description
        @expected_pattern_service = @service_3
        @iut.register_service(@service_3)
        @iut.register_service_definition(@service_3['name'], @service_definition_1)
      end

      def given_service_with_pattern_in_definition
        @expected_pattern_service = @service_5
        @iut.register_service(@service_5)
        @iut.register_service_definition(@service_5['name'], @service_definition_1)
      end

      def given_service_has_matching_uri_endpoint
        clear_service_endpoints(service_name)
        @iut.add_service_uri(service_name, @service_uri_1)
      end

      def given_services_have_matching_uri_endpoints
        clear_service_endpoints(@service_3['name'])
        @iut.add_service_uri(@service_3['name'], @service_uri_1)

        clear_service_endpoints(@service_4['name'])
        @iut.add_service_uri(@service_4['name'], @service_uri_1)
      end

      def given_service_has_matching_uri_endpoints
        clear_service_endpoints(service_name)
        @iut.add_service_uri(service_name, @service_uri_1)

        clear_service_endpoints(service_name)
        @iut.add_service_uri(service_name, @service_uri_2)
      end

      def no_services_match_need
        @need = 'no services match this'
      end

      def no_services_match_pattern
        process_result(@iut.list_services)
        data['services'].each do |service, detail|
          @iut.deregister_service(service)
        end
      end

      def register_service
        # byebug
        process_result(@iut.register_service(@service))
      end

      def deregister_service
        process_result(@iut.deregister_service(service_name))
      end

      def match_need
        # byebug
        process_result(@iut.search_for_service(@need))
      end

      def provide_one_matching_service
        @service = @service_1['name']
        @iut.register_service(@service_1)
        @iut.register_service_definition(@service_1['name'], @service_definition_1)
        @iut.deregister_service(@service_2['name']) if @iut.service_registered?(@service_2['name'])
      end

      def provide_two_matching_services
        @iut.register_service(@service_1)
        @iut.register_service(@service_2)
        @iut.register_service_definition(@service_1['name'], @service_definition_1)
        @iut.register_service_definition(@service_2['name'], @service_definition_1)
      end

      def configure_service_uri
        process_result(@iut.add_service_uri(service_name, @uri))
      end

      def remove_uri_from_service
        process_result(@iut.remove_uri_from_service(service_name, @uri))
      end

      def request_service_uris
        process_result(@iut.service_uris(service_name))
      end

      def search_for_pattern_in_endpoints
        process_result(@iut.search_services_for_uri(@uri))
      end

      def has_received_service_and_matching_uri
        data['services'].each do |service, uri|
          return true if ((service == @service['name']) and (uri.include?(@service_uri_1)))
        end
        false
      end

      def has_received_services_and_matching_uris
        found_first = false
        found_second = false
        data['services'].each do |service, uri|
          found_first  = true if ((service == @service_3['name']) and (uri.include?(@service_uri_1)))
          found_second = true if ((service == @service_4['name']) and (uri.include?(@service_uri_1)))
        end
        found_first and found_second
      end

      def has_received_service_and_matching_uris
        found_first = false
        found_second = false
        data['services'].each do |service, uri|
          found_first  = true if ((service == @service['name']) and (uri.include?(@service_uri_1)))
          found_second = true if ((service == @service['name']) and (uri.include?(@service_uri_2)))
        end
        found_first and found_second
      end

      def has_received_service_uris?
        uris = []
        data['bindings'].each do |binding, detail|
          uris << detail['access_point']
        end  
        arrays_the_same?(@pre_uris, uris)
      end

      def remember_uri?
        process_result(@iut.service_uris(service_name))
        uris = data['bindings']
        uris.each do |binding, detail|
          return true if detail['access_point'] == @uri
        end
        false
      end

      def service_by_name
        process_result(@iut.service_by_name(@service))
      end

      def multiple_existing_services
        @iut.register_service(@service_3)
        @iut.register_service(@service_4)
        @expected_pattern_service = @service_4
        @iut.register_service_definition(@service_4['name'], @service_definition_1)
      end

      def multiple_existing_service_components
        @iut.register_service_component(@service_component_1)
        @iut.register_service_component(@service_component_2)
        @iut.associate_service_component_with_service(@service_4['name'], @service_uri_2)
        @iut.associate_service_component_with_service(@service_1['name'], @service_uri_1)
      end

      def multiple_existing_domain_perspectives
        @iut.register_domain_perspective(@domain_perspective_1)
        @iut.delete_all_domain_perspective_associations(@domain_perspective_1)
        @iut.register_domain_perspective(@domain_perspective_2)
        @iut.delete_all_domain_perspective_associations(@domain_perspective_2)
      end

      def services_associated_with_different_domain_perspectives
        # byebug
        @iut.register_service(@service_3)
        @iut.associate_service_with_domain_perspective(@service_3['name'], @domain_perspective_1)
        @iut.register_service(@service_4)
        @iut.associate_service_with_domain_perspective(@service_4['name'], @domain_perspective_2)
      end

      def match_pattern_in_domain_perspective
        # byebug
        process_result(@iut.search_domain_perspective(@domain_perspective_1, @need))
      end

      def service_definitions
        process_result(@iut.service_definitions(service_component))
      end

      def received_no_services?
        success? and (data['services'] == [])
      end

      def service_available?
        id = @service.nil? ? "" : @service['name']
        process_result(@iut.service_registered?(id))
        data['registered']
      end

      def service_available_lowercase?
        id = @service.nil? ? "" : @service['name'].downcase
        process_result(@iut.service_registered?(id))
        data['registered']
      end

      def services_found?
        (not data.nil?) and (not data['services'].nil?) and (not data['services'].empty?)
      end

      def single_service_match?
        (data['services'].count == 1) and (data['services'].first[1]['name'] == @service_1['name'])
      end

      def multiple_services_match?
        return false if not (data['services'].count == 2)
        found_1 = false
        found_2 = false
        data['services'].each do |id, service|
          return false if not ((service['name'] == @service_1['name']) or (service['name'] == @service_2['name']))
          found_1 = true if (not(found_1) and (service['name'] == @service_1['name']))
          found_2 = true if (not(found_2) and (service['name'] == @service_2['name']))
        end
        found_1 and found_2
      end

      def entry_matches?
        data['services'].first[1]['name'].include?(@need) == true
      end

      def both_entries_match?
        return false if not (data['services'].count == 2)
        found_1 = false
        found_2 = false
        data['services'].each do |id, service|
          found_2 = true if (found_1 and not(found_2) and (service['name'].include?(@need)))
          found_1 = true if (not(found_1) and (service['name'].include?(@need)))
        end
        found_1 and found_2
      end

      def service_matched_pattern?
        (data['services'].count == 1) and (data['services'].first[1]['name'] == @expected_pattern_service['name'])
      end

      def matched_pattern_in_domain_perspectice?
        data['services'].size == 1
      end

      def matched_only_in_domain_perspective?
        # byebug
        data['services'].first[1]['name'] == @service_3['name']
      end

      def has_list_of_service_components_providing_service?
        data['services'].first[1]['uris'].count > 0
      end

      def received_empty_list_of_service_components?
        data['services'].first[1]['uris'].count == 0
      end

      def has_list_of_both_service_components_providing_service?
        access_points = []
        data['services'].first[1]['uris'].each do |id, uri|
        # byebug
          access_points << uri['access_point']
        end

        (access_points.count > 0) and (access_points.include?(@service_uri_1) and access_points.include?(@service_uri_2))
      end

      def has_uri_to_service_component_providing_service?
        access_points = []
        data['services'].first[1]['uris'].each do |id, uri|
          access_points << uri['access_point']
        end

        (access_points.count > 0) and (access_points.include?(@service_uri_1))
      end

      def has_status_of_service_component_providing_service?
        sc = data['services'].first[1]['service_components'][@service_component]
        sc['status'] == '100'
      end

      def service_uris_changed?
        @iut.fix
        not arrays_the_same?(@pre_uris, extract_service_uris)
      end

      def clear_service_endpoints(name)
        @iut.configure_meta_for_service(name, {})
      end
    end
  end
end
