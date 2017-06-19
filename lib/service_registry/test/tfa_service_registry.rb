require 'uri'
require 'service_registry'
require 'json'
require 'soap4juddi'
require 'jsender'

require "service_registry/providers/bootstrapped_provider"
require "service_registry/providers/dss_associate"

module ServiceRegistry
  module Test
    class TfaServiceRegistry < ServiceRegistry::Providers::BootstrappedProvider
      include ServiceRegistry::Providers::DssAssociate
      include Jsender

      ALL_SERVICES = nil unless defined? ALL_SERVICES; ALL_SERVICES.freeze
            
      attr_writer :authorized

      def initialize(uri, fqdn, company_name, credentials)
        @urns = { 'base' => ServiceRegistry::HETZNER_BASE_URN,
                 'company' => ServiceRegistry::HETZNER_URN,
                 'domains' => ServiceRegistry::HETZNER_DOMAINS_URN,
                 'teams' => ServiceRegistry::HETZNER_TEAMS_URN,
                 'services' => ServiceRegistry::HETZNER_SERVICES_URN,
                 'service-components' => ServiceRegistry::HETZNER_SERVICE_COMPONENTS_URN}

        @tfa_uri = uri
        broker = ::Soap4juddi::Broker.new(@urns)
        broker.base_uri = @tfa_uri
        @juddi = ServiceRegistry::Providers::JUDDIProvider.new(@urns, broker)
        @authorized = true
        @credentials = credentials

        # stub out the bootstrapping environment
        @configuration_bootstrap = {'CFGSRV_PROVIDER_ADDRESS' => 'https://127.0.0.1', 'CFGSRV_TOKEN' => 'abcd', 'CFGSRV_IDENTIFIER' => 'identifier' }
        stub = ServiceRegistry::Test::StubConfigurationService.new
        stub.configure(@configuration_bootstrap)
        bootstrap(@configuration_bootstrap, stub)
      end

      def fix
        @juddi.broker.base_uri = @tfa_uri
        @broken = false
      end

      def break
        @juddi.broker.base_uri = "http://127.0.0.1:9992"
        @broken = true
      end

      # ---- services ----

      def register_service(service)
        service = standardize(service)
        authorize
        result = validate_hash_present(service, 'name', 'service'); return result if result
        return fail('service already exists') if is_registered?(service_registered?(service['name']))

        description = []
        description << service ['description'] if service['description']
        description << service ['meta'] if service['meta']

        result = @juddi.save_service(service['name'], description, service['definition'])
        validate_and_succeed(result, 'service', 'service registered')

        rescue => ex
          fix if @broken
          fail('failure registering service')
      end

      def service_registered?(service)
        service = standardize(service)
        result = @juddi.find_services(service)
        registered = false
        if has_data?(result, 'services')
          result['data']['services'].each do |service_key, description|
            registered = (service.downcase == service_key.downcase)
          end
        end
        success_data({'registered' => registered})
      end

      def deregister_service(service)
        service = standardize(service)
        authorize
        result = validate_field_present(service, 'service'); return result if result
        return success('unknown service provided') if not is_registered?(service_registered?(service))
        result = @juddi.delete_service(service)
        validate_and_succeed(result, 'service', 'service deregistered')

      rescue => ex
        fix if @broken
        fail('failure deregistering service')        
      end

      def add_service_uri(service, uri)
        service = standardize(service)
        authorize
        result = validate_field_present(service, 'service'); return result if result
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        return fail('unknown service provided') if not is_registered?(service_registered?(service))
        result = @juddi.add_service_uri(service, uri)

        validate_and_succeed(result, 'service')

      rescue => ex
        fix if @broken
        fail('failure configuring service')        
      end

      def service_uris(service)
        service = standardize(service)
        authorize
        result = validate_field_present(service, 'service'); return result if result

        return fail('unknown service provided') if not is_registered?(service_registered?(service))
        result = @juddi.service_uris(service)
        validate_and_succeed(result, 'service', '', result['data'])

      rescue => ex
        fix if @broken
        fail('failure listing service URIs')        
      end

      def remove_uri_from_service(service, uri)
        service = standardize(service)
        authorize
        result = validate_field_present(service, 'service'); return result if result
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        return fail('unknown service provided') if not is_registered?(service_registered?(service))

        result = @juddi.remove_service_uri(service, uri)

        validate_and_succeed(result, 'service')

      rescue => ex
        fix if @broken
        fail('failure removing URI from service')        
      end

      def service_associations(service)
        service = standardize(service)
        authorize
        result = validate_field_present(service, 'service'); return result if result
        return success('unknown service provided') if not is_registered?(service_registered?(service))

        associations = {}
        uris = {}
        domain_perspectives = {}

        bindings = service_uris(service)['data']['bindings']
        bindings ||= {}
        bindings.each do |id, detail|
          uris[id] = detail['access_point']
        end

        domain_perspectives_list = list_domain_perspectives['data']['domain_perspectives']
        domain_perspectives_list ||= {}
        domain_perspectives_list.each do |domain_perspective, detail|
          services = domain_perspective_associations(domain_perspective)['data']['associations']['services']
          services.each do |sv, associated|
            serv = sv.gsub(@urns['services'], "")
            domain_perspectives[detail['id']] = domain_perspective if (serv.downcase == service) and (associated == true)
          end
        end
        associations['domain_perspectives'] = domain_perspectives
        success_data({'uris' => uris, 'associations' => associations})
      rescue => ex
        fix if @broken
        fail('failure determining associations for service')           
      end

      # ---- service definition ----

      def register_service_definition(service, definition)
        service = standardize(service)
        authorize 
        result = validate_field_present(service, 'service'); return result if result
        return success('unknown service provided') if not is_registered?(service_registered?(service))
        return fail('no service definition provided') if definition.nil?
        return fail('invalid service definition provided') if not definition.include?("wadl")

        result = @juddi.get_service(service)
        service = result['data']
        service['definition'] = definition
        result = @juddi.save_service(service['name'], service['description'], service['definition'])
        validate_and_succeed(result, 'service', 'service definition registered')
      rescue => ex
        fix if @broken
        fail('failure registering service definition')           
      end

      def service_definition_for_service(service)
        service = standardize(service)
        result = validate_field_present(service, 'service'); return result if result
        return success('unknown service provided') if not is_registered?(service_registered?(service))
        result = @juddi.get_service(service)['data']
        return fail('invalid service provided') if notifications_include?(result, 'E_invalidKeyPassed')
        return fail('service has no definition') if (result['definition'].nil?) or (result['definition'] == "")
        return success_data({'definition' => result['definition']}) if (not result.nil?) and (not result['definition'].nil?)
      end

      def deregister_service_definition(service)
        service = standardize(service)
        authorize
        result = validate_field_present(service, 'service'); return result if result
        return success('unknown service provided') if not is_registered?(service_registered?(service))
        result = @juddi.get_service(service)
        service = result['data']
        service['definition'] = ""
        result = @juddi.save_service(service['name'], service['description'], service['definition'])
        validate_and_succeed(result, 'service', 'service definition deregistered')
      end

      # ---- domain perspectives ----      

      def reset_domain_perspectives
        authorize
        return if not @authorized
        result = list_domain_perspectives
        if has_data?(result, 'domain_perspectives') 
          result['data']['domain_perspectives'].each do |name, detail|
            @juddi.delete_business(detail['id'])
          end
        end
      end

      def list_domain_perspectives
        result = @juddi.find_businesses
        result['data']['domain_perspectives'] = {}

        if has_data?(result, 'businesses')
          result['data']['businesses'].each do |business, detail|
            hetz = false
            ServiceRegistry::HETZNER_DOMAIN_TYPES.each do |type|
              hetz = true if detail['id'].include?(type)
            end
            result['data']['domain_perspectives'][business] = detail if hetz
          end
        end
        result

      rescue => ex
        fix if @broken
        fail('failure listing domain perspectives')          
      end

      def domain_perspective_registered?(domain_perspective)
        domain_registered?('domains', domain_perspective)
      end

      def register_domain_perspective(domain_perspective)
        register_domain('domains', domain_perspective)
      end

      def deregister_domain_perspective(domain_perspective)
        deregister_domain('domains', domain_perspective)
      end

      # ---- teams ----

      def team_registered?(domain_perspective)
        domain_registered?('teams', domain_perspective)
      end

      def register_team(domain_perspective)
        register_domain('teams', domain_perspective)
      end

      def deregister_team(domain_perspective)
        deregister_domain('teams', domain_perspective)
      end      

      # ---- service components ----
      def list_service_components(domain_perspective = nil)
        domain_perspective = standardize(domain_perspective)
        result = @juddi.find_service_components
        service_components = has_data?(result, 'services') ? result['data']['services'] : {}
        found = []

        if not domain_perspective.nil?
          return fail('unknown domain perspective provided') if not is_registered?(domain_perspective_registered?(domain_perspective))
          associations = domain_perspective_associations(domain_perspective)['data']['associations']['service_components']
          return success_data({'service_components' => []}) if associations.count == 0
          
          associations.each do |id, associated|
            if associated
              service_components.each do |sid, service_component|
                found << sid if compile_domain_id('service-components', sid) == id
              end
            end
          end
        else
          service_components.each do |sid, service_component|
            found << sid
          end
        end

        success_data('service_components' => found)

      rescue => ex
        fix if @broken
        fail('failure retrieving service components')           
      end

      def delete_all_service_components
        authorize
        return if not @authorized
        result = list_service_components
        if has_data?(result, 'service_components') 
          result['data']['service_components'].each do |service_component, description|
            @juddi.delete_service_component(service_component)
          end
        end
      end

      def service_component_registered?(service_component)
        service_component = standardize(service_component)
        result = @juddi.find_service_components(service_component)
        registered = false
        if has_data?(result, 'services')
          result['data']['services'].each do |service_key, description|
            registered = (service_component.downcase == service_key.downcase)
          end
        end
        success_data({'registered' => registered})
      end

      def register_service_component(service_component)
        service_component = standardize(service_component)
        authorize
        result = validate_field_present(service_component, 'service component'); return result if result
        return fail('service component already exists') if is_registered?(service_component_registered?(service_component))

        result = @juddi.save_service_component(service_component)
        validate_and_succeed(result, 'service component', 'service component registered')        

        rescue => ex
          fix if @broken
          fail('failure registering service component')
      end

      def service_component_has_domain_perspective_associations?(service_component)
        service_component = standardize(service_component)
        domain_perspectives = list_domain_perspectives['data']['domain_perspectives']
        domain_perspectives.each do |name, detail|
          service_components = domain_perspective_associations(name)['data']['associations']['service_components']
          service_components.each do |id, value|
            return true if (id == compile_domain_id('service-components', service_component)) and (value)
          end
        end
        false
      end

      def deregister_service_component(service_component)
        service_component = standardize(service_component)
         authorize
         return fail('no service component provided') if service_component.nil?
         return fail('invalid service component provided') if service_component.strip == ""
         return success('unknown service component provided') if not is_registered?(service_component_registered?(service_component))
         return fail('service component has domain perspective associations') if service_component_has_domain_perspective_associations?(service_component)
         result = @juddi.delete_service_component(service_component)
         validate_and_succeed(result, 'service component', 'service component deregistered') 

       rescue => ex
         fix if @broken
         fail('failure deregistering service component')        
      end

      def associate_service_component_with_service(service, access_point, description = '')
        service = standardize(service)
        authorize
        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "") or not is_registered?(service_registered?(service))
        return fail('no access point provided') if access_point.nil?
        return fail('invalid access point provided') if not (access_point =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        result = @juddi.add_service_uri(service, access_point)
        validate_and_succeed(result, 'service or access point')         

       rescue => ex
         fix if @broken
         fail('failure associating service component with service')
      end

      def configure_service_component_uri(service_component, uri)
        service_component = standardize(service_component)
        authorize
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('unknown service component provided') if not is_registered?(service_component_registered?(service_component))
        return fail('no URI provided') if uri.nil?
        return fail('invalid URI') if not (uri =~ URI::DEFAULT_PARSER.regexp[:UNSAFE]).nil?
        result = @juddi.save_service_component_uri(service_component, uri)
        validate_and_succeed(result, 'service component or URI')         

       rescue => ex
         fix if @broken
         fail('failure configuring service component')
      end

      def service_component_uri(service_component)
        service_component = standardize(service_component)
        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('unknown service component provided') if not is_registered?(service_component_registered?(service_component))
        result = @juddi.find_service_component_uri(service_component)
        return fail('invalid service component provided') if notifications_include?(result, 'E_invalidKeyPassed')
        uri = (has_data?(result, 'bindings') and (result['data']['bindings'].size > 0)) ? result['data']['bindings'].first[1]['access_point'] : nil
        result['data']['uri'] = uri
        result
      end   

      # ---- meta ----
      def configure_meta_for_service(service, meta)
        service = standardize(service)
        authorize

        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (service.strip == "")
        return fail('unknown service provided') if not is_registered?(service_registered?(service))

        return fail('no meta provided') if meta.nil?
        return fail('invalid meta') if not meta.is_a?(Hash)

        descriptions = []
        detail = @juddi.get_service(service)['data']
        detail['description'] ||= {}
        detail['description'].each do |desc|
          descriptions << desc if not description_is_meta?(desc)
        end

        descriptions << CGI.escape(meta.to_json)

        detail = @juddi.get_service(service)['data']
        detail['description'] = descriptions

        result = @juddi.save_service(detail['name'], detail['description'], detail['definition'])
        validate_and_succeed(result, 'meta', 'meta updated', result['data'])
       rescue => ex
         fix if @broken
         fail('failure configuring service with meta')
      end

      def configure_meta_for_service_component(service_component, meta)
        service_component = standardize(service_component)
        authorize

        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (service_component.strip == "")
        return fail('unknown service component provided') if not is_registered?(service_component_registered?(service_component))

        return fail('no meta provided') if meta.nil?
        return fail('invalid meta') if not meta.is_a?(Hash)

        descriptions = []
        detail = @juddi.get_service_component(service_component)['data']
        detail['description'] ||= {}
        detail['description'].each do |desc|
          descriptions << desc if not description_is_meta?(desc)
        end

        descriptions << CGI.escape(meta.to_json)

        detail = @juddi.get_service_component(service_component)['data']
        detail['description'] = descriptions

        result = @juddi.save_service_component(detail['name'], detail['description'], detail['definition'])
        validate_and_succeed(result, 'meta', 'meta updated', result['data'])
       rescue => ex
         fix if @broken
         fail('failure configuring service component with meta')
      end      

      def meta_for_service(service)
        service = standardize(service)
        detail = @juddi.get_service(service)['data']
        if detail['description']
          detail['description'].each do |desc|
            return JSON.parse(CGI.unescape(desc)) if (description_is_meta?(desc))
          end
        end

        {}
      end

      def meta_for_service_component(service_component)
        service_component = standardize(service_component)
        detail = @juddi.get_service_component(service_component)['data']
        if detail['description']
          detail['description'].each do |desc|
            return JSON.parse(CGI.unescape(desc)) if (description_is_meta?(desc))
          end
        end

        {}
      end

      def configure_meta_for_domain_perspective(type, domain_perspective, meta)
        domain_perspective = standardize(domain_perspective)
        authorize

        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "")

        return fail('no meta provided') if meta.nil?
        return fail('invalid meta') if not meta.is_a?(Hash)
        descriptions = []
        detail = nil
        id = compile_domain_id(type, domain_perspective)
        detail = @juddi.get_business(id)['data'][domain_perspective]
        detail ||= {}
        detail['id'] = id
        detail['description'] ||= []        
        detail['description'].each do |desc|
          descriptions << desc if not description_is_meta?(desc)
        end

        associations = {}.merge!(meta['associations']) if meta['associations']
        associations['service_components'] ||= {}
        associations['services'] ||= {}
        meta.delete('associations')
        associations['service_components'].each do |id, value|
          descriptions << CGI.escape({'associations' => {'service_components' => {id => value}}}.to_json)
        end
        associations['services'].each do |id, value|
          descriptions << CGI.escape({'associations' => {'services' => {id => value}}}.to_json)
        end

        descriptions << CGI.escape(meta.to_json) if meta.count > 0

        detail['description'] = descriptions

        result = @juddi.save_business(detail['id'], detail['name'], detail['description'])

        validate_and_succeed(result, 'meta', 'meta updated', result['data'])
       rescue => ex
         fix if @broken
         fail('failure configuring domain perspective with meta')
      end

      def meta_for_domain_perspective(type, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        id = compile_domain_id(type, domain_perspective)
        detail = @juddi.get_business(id)['data'][domain_perspective]
        detail ||= {}
        meta = {}
# byebug
        if detail['description']
          detail['description'].each do |desc|
            meta.merge!(JSON.parse(CGI.unescape(desc))) if (description_is_meta?(desc))
          end
        end

        meta
      end

      # ---- search ----
      def check_dss(name)
        result = @dss.query(name)
        return false if result.nil? or result == 'error'
        result
      end

      def query_service_by_pattern(pattern)
        result = @juddi.find_services
        list = {}        
        if has_data?(result, 'services')
          result['data']['services'].each do |service, name|
            detail = @juddi.get_service(service)
            if has_data?(detail, 'description')
              found = false
              dss = nil
              detail['data']['description'].each do |description|
                found = true if (description and description.include?(pattern))
                dss = description.gsub("dss:", "").strip if (description and description.include?('dss:'))
              end
              list[service] = detail if ((dss and (@dss and check_dss(service))) or (not dss)) and found
            end
          end
        end
        
        success_data({ 'services' => list })
      end

      def list_services
        search_for_service_by_pattern(ALL_SERVICES)
      end

      def search_for_service(pattern)
        return fail('no pattern provided') if pattern.nil?
        return fail('invalid pattern provided') if (pattern.size < 4)

        search_for_service_by_pattern(pattern)
      end     

      def service_by_name(name)
        name = standardize(name)
        return fail('invalid service provided') if name.nil? or (name.strip == "")

        result = search_for_service(name)
        if has_data?(result, 'services')
          result['data']['services'].each do |sname, service|
            compare_service = "#{ServiceRegistry::HETZNER_SERVICES_URN}#{name}" == sname
            compare_service_component = "#{ServiceRegistry::HETZNER_SERVICE_COMPONENTS_URN}#{name}" == sname
            return success_data({ 'services' => { sname => service }}) if compare_service or compare_service_component or (name == sname)
          end
          success_data({ 'services' => {}})
        else
          fail('failure finding service by name')
        end
      end 

      def search_domain_perspective(domain_perspective, pattern)
        domain_perspective = standardize(domain_perspective)
        found = {}
        data = domain_perspective_associations(domain_perspective)['data']['associations']
        service_components = data['service_components']
        services = data['services']
        associations = service_components.merge(services)
        associations.each do |service|
          found[service[0]] = @juddi.get_service(service[0])['data']
        end
        success_data({'services' => found})
      end

      def search_services_for_uri(pattern)
        return fail('no pattern provided') if pattern.nil?
        return fail('invalid pattern provided') if (pattern.size < 4)
        result = search_for_service_by_pattern(ALL_SERVICES)['data']['services']
        result ||= {}
        found = {}
        result.each do |service, detail|
          uris = detail['uris']
          uris ||= {}
          included = false
          uris.each do |id, access_details|
            uri = access_details['access_point']
            if (not((uri =~ /#{pattern}/i).nil?))
              found[service] ||= []
              found[service] << uri
            end
          end
        end

        success_data({'services' => found})       
      end
      # ---- associations ----

      def delete_all_domain_perspective_associations(domain_perspective)
        domain_perspective = standardize(domain_perspective)
        associations = domain_perspective_associations(domain_perspective)['data']['associations']
        associations.each do |id, value|
          disassociate_service_component_from_domain_perspective(domain_perspective, id)
        end
        success
      end

      def associate_service_component_with_domain_perspective(service_component, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        service_component = standardize(service_component)
        #byebug
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (not is_registered?(domain_perspective_registered?(domain_perspective)))

        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (not is_registered?(service_component_registered?(service_component)))

        service_component_id = compile_domain_id('service-components', service_component)
        meta = meta_for_domain_perspective('domains', domain_perspective)
        meta['associations'] ||= {}
        meta['associations']['service_components'] ||= {}
        meta['associations']['services'] ||= {}

        return fail('already associated') if meta['associations']['service_components'][service_component_id]

        meta['associations']['service_components'][service_component_id] = true
        result = configure_meta_for_domain_perspective('domains', domain_perspective, meta)

       rescue => ex
         fix if @broken
         fail('failure associating service component with domain perspective')        
      end

      def associate_service_with_domain_perspective(service, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        service = standardize(service)
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (not is_registered?(domain_perspective_registered?(domain_perspective)))

        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (not is_registered?(service_registered?(service)))

        service_id = compile_domain_id('services', service)
        meta = meta_for_domain_perspective('domains', domain_perspective)

        meta['associations'] ||= {}
        meta['associations']['service_components'] ||= {}
        meta['associations']['services'] ||= {}
        return fail('already associated') if meta['associations']['services'][service_id]

        meta['associations']['services'][service_id] = true
        result = configure_meta_for_domain_perspective('domains', domain_perspective, meta)

       rescue => ex
         fix if @broken
         fail('failure associating service with domain perspective')        
      end

      def disassociate_service_component_from_domain_perspective(domain_perspective, service_component)
        domain_perspective = standardize(domain_perspective)
        service_component = standardize(service_component)
        # byebug
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (not is_registered?(domain_perspective_registered?(domain_perspective)))

        return fail('no service component provided') if service_component.nil?
        return fail('invalid service component provided') if (not is_registered?(service_component_registered?(service_component)))

        service_component_id = compile_domain_id('service-components', service_component)
        meta = meta_for_domain_perspective('domains', domain_perspective)
        meta['associations'] ||= {}
        meta['associations']['service_components'] ||= {}
        meta['associations']['services'] ||= {}

        return fail('not associated') if not meta['associations']['service_components'][service_component_id]

        meta['associations']['service_components'].delete(service_component_id)
        result = configure_meta_for_domain_perspective('domains', domain_perspective, meta)

       rescue => ex
         fix if @broken
         fail('failure disassociating service component from domain perspective')        
      end

      def disassociate_service_from_domain_perspective(domain_perspective, service)
        domain_perspective = standardize(domain_perspective)
        service = standardize(service)
        # byebug
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (not is_registered?(domain_perspective_registered?(domain_perspective)))

        return fail('no service provided') if service.nil?
        return fail('invalid service provided') if (not is_registered?(service_registered?(service)))

        service_id = compile_domain_id('services', service)
        meta = meta_for_domain_perspective('domains', domain_perspective)
        meta['associations'] ||= {}
        meta['associations']['service_components'] ||= {}
        meta['associations']['services'] ||= {}

        return fail('not associated') if not meta['associations']['services'][service_id]

        meta['associations']['services'].delete(service_id)
        result = configure_meta_for_domain_perspective('domains', domain_perspective, meta)

       rescue => ex
         fix if @broken
         fail('failure disassociating service from domain perspective')        
      end

      def domain_perspective_associations(domain_perspective)
        domain_perspective = standardize(domain_perspective)
        meta = meta_for_domain_perspective('domains', domain_perspective)
        meta['associations'] ||= {}
        meta['associations']['service_components'] ||= {}
        meta['associations']['services'] ||= {}
        success_data(meta)
      end

      def add_contact_to_domain_perspective(domain_perspective, contact)
        domain_perspective = standardize(domain_perspective)
        return fail('failure adding contact') if @broken        
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if domain_perspective.strip == ""
        result = domain_perspective_registered?(domain_perspective)
        return fail('unknown domain perspective provided') if not is_registered?(result)
        return fail('no contact details provided') if not contact
        return fail('invalid contact details provided') if (not contact.is_a?(Hash)) or (contact == {}) or (contact['name'].nil?) or (contact['name'].strip == "")
        details = {}.merge!(contact)
        details = ensure_required_contact_details(details)

        domain_perspectives = find_domain('teams', domain_perspective)
        domain_perspectives = find_domain('domains', domain_perspective) if domain_perspectives['data']['result'].nil?

        id = domain_perspectives['data'].first[1]['id']
        domain_perspective = @juddi.get_business(id)['data'].first[1]

        domain_perspective['contacts'] ||= []

        return fail('contact already exists - remove first to update') if contacts_include?(domain_perspective['contacts'], details)

        domain_perspective['contacts'] << details

        result = @juddi.save_business(id, domain_perspective['name'], domain_perspective['description'], domain_perspective['contacts'])
        result
      end

      def contact_details_for_domain_perspective(domain_perspective)
        domain_perspective = standardize(domain_perspective)
        return fail('failure retrieving contact details') if @broken
        return fail('no domain perspective provided') if not domain_perspective
        return fail('invalid domain perspective provided') if (domain_perspective and domain_perspective.strip == "")  
        result = domain_perspective_registered?(domain_perspective)
        return fail('unknown domain perspective provided') if not is_registered?(result)
        id = result['data']['id']
        domain_perspective = @juddi.get_business(id)['data'].first[1]
        domain_perspective['contacts'] ||= []
        domain_perspective['contacts'].each do |contact|
          contact['description'] = '' if contact['description'] == 'n/a'
          contact['email'] = '' if contact['email'] == 'n/a'
          contact['phone'] = '' if contact['phone'] == 'n/a'
        end
        success_data('contacts' => domain_perspective['contacts'])
      end      

      def remove_contact_from_domain_perspective(domain_perspective, contact)
        domain_perspective = standardize(domain_perspective)
        return fail('failure removing contact') if @broken        
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if domain_perspective.strip == ""
        result = domain_perspective_registered?(domain_perspective)
        return fail('unknown domain perspective provided') if not is_registered?(result)
        return fail('no contact details provided') if not contact
        return fail('invalid contact details provided') if (not contact.is_a?(Hash)) or (contact == {})

        domain_perspectives = find_domain('teams', domain_perspective)
        domain_perspectives = find_domain('domains', domain_perspective) if domain_perspectives['data']['result'].nil?

        id = domain_perspectives['data'].first[1]['id']

        domain_perspective = @juddi.get_business(id)['data'].first[1]
        domain_perspective['contacts'] ||= []

        return fail('unknown contact') if not contacts_include?(domain_perspective['contacts'], contact)

        domain_perspective['contacts'].delete(contact)
        domain_perspective['contacts'] = nil if domain_perspective['contacts'] == []

        result = @juddi.save_business(id, domain_perspective['name'], domain_perspective['description'], domain_perspective['contacts'])
      end      

      private

      def search_for_service_by_pattern(pattern, include_service_components = true)
        services = @juddi.find_services(pattern)['data']['services']
        service_components = @juddi.find_service_components(pattern)['data']['services'] if include_service_components
        services ||= {}
        services_detailed = {}
        services.each do |id, service|
          service['uris'] = service_uris(service['name'])['data']['bindings'] #evg
        end      

        services_detailed = {}
        services.each do |id, service|
          service['uris'] = service_uris(service['name'])['data']['bindings']
        end

        service_components ||= {}
        found = services.merge!(service_components) if include_service_components
        # byebug

        success_data({'services' => found})
      end

      def ensure_required_contact_details(details)
        details['description'] = 'n/a' if details['description'].nil? or details['description'].strip == ""
        details['email'] = 'n/a' if details['email'].nil? or details['email'].strip == ""
        details['phone'] = 'n/a' if details['phone'].nil? or details['phone'].strip == ""
        details
      end

      def contacts_include?(contacts, contact)
        contacts.each do |compare|
          return true if (compare['name'] == contact['name']) and (compare['email'] == contact['email']) and (compare['description'] == contact['description']) and (compare['phone'] == contact['phone'])
        end
        false
      end

      def find_domain(type, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        result = @juddi.find_businesses(domain_perspective)
        if has_data?(result, 'businesses')
          result['data']['businesses'].each do |business, detail|
            return success_data(business => detail) if (domain_perspective.downcase == business.downcase) and (detail['id'].include?(type))
          end
        end
        success
      end

      def domain_registered?(type, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        result = @juddi.find_businesses(domain_perspective)
        registered = false
        id = nil
        if has_data?(result, 'businesses')
          result['data']['businesses'].each do |business, detail|
            if (domain_perspective.downcase == business.downcase) and (detail['id'].include?(type))
              registered = true
              id = detail['id']
              break
            end
          end
        end
        success_data({'registered' => registered, 'id' => id})
      end

      def register_domain(type, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        authorize
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if (domain_perspective.strip == "") or (not ServiceRegistry::HETZNER_DOMAIN_TYPES.include?(type.downcase))
        return fail('domain perspective already exists') if is_registered?(domain_perspective_registered?(domain_perspective))

        id = compile_domain_id(type, domain_perspective)
        result = @juddi.save_business(id, domain_perspective)

        validate_and_succeed(result, 'domain perspective', 'domain perspective registered')
      rescue => ex
        fix if @broken
        fail('failure registering domain perspective')     
      end

      def compile_domain_id(type, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        "#{@urns[type]}#{domain_perspective}"
      end

      def domain_perspective_has_associations?(domain_perspective)
        domain_perspective = standardize(domain_perspective)
        associations = domain_perspective_associations(domain_perspective)['data']['associations']
        (associations['service_components'].size > 0) or (associations['services'].size > 0)
      end

      def deregister_domain(type, domain_perspective)
        domain_perspective = standardize(domain_perspective)
        authorize
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if domain_perspective.strip == ""

        return fail('unknown domain perspective provided') if not is_registered?(domain_perspective_registered?(domain_perspective))
        return fail('domain perspective has associations') if domain_perspective_has_associations?(domain_perspective)

        result = @juddi.delete_business(compile_domain_id(type, domain_perspective))
        validate_and_succeed(result, 'domain perspective', 'domain perspective deregistered')

      rescue => ex
        fix if @broken
        fail('failure deregistering domain perspective')        
      end

      def authorize
        raise RuntimeError.new("Not available / properly initialized") if not available?['data']['available']
        @juddi.broker.authenticate(@credentials['username'], @credentials['password']) if @authorized
        @juddi.broker.authenticate('', '') if not @authorized
      end

      def is_registered?(result)
        has_data?(result, 'registered') and result['data']['registered']
      end

      def description_is_meta?(meta)
        JSON.parse(CGI.unescape(meta))
        true
      rescue => ex
        false
      end

      def validate_and_succeed(result, element, message = nil, data = nil)
        return fail('invalid #{element} identifier provided') if notifications_include?(result, 'E_invalidKeyPassed')
        return fail('not authorized') if notifications_include?(result, 'E_authTokenRequired')
        if (message.nil? or message == '')
          return success_data(data) if data
          return success
        else
          return success_data(message, data) if data
          return success(message)
        end
      end

      def validate_hash_present(field, key, element)
        return fail("no #{element} provided") if field.nil? or field[key].nil?
        return fail("invalid #{element} provided") if ((not field.is_a? Hash) or (field[key].strip == ""))
      end

      def validate_field_present(field, element)
        return fail("no #{element} provided") if field.nil?
        return fail("invalid #{element} provided") if field.strip == ""        
      end

    def standardize(name)
      return standardize_dictionary(name) if name.is_a?(Hash)
      return standardized = name.to_s.downcase if not name.nil?
      nil
    end

    def standardize_dictionary(dictionary)
      value = standardize(dictionary['name'])
      standardized = dictionary
      standardized['name'] = value
      standardized
    end

    end
  end
end
