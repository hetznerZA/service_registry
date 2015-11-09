require 'uri'
require 'service_registry'

module ServiceRegistry
  module Test
    class TfaServiceRegistry < ServiceRegistry::Providers::JSendProvider
      attr_writer :authorized

      def initialize
        @tfa_uri = "http://localhost:8080"
        @juddi = ServiceRegistry::Providers::JUDDIProvider.new(ServiceRegistry::HETZNER_BASE_URN,
                                                               ServiceRegistry::HETZNER_URN,
                                                               ServiceRegistry::HETZNER_DOMAINS_URN,
                                                               ServiceRegistry::HETZNER_SERVICES_URN)
        @juddi.set_uri(@tfa_uri)
        @authorized = true
        @credentials = { 'username' => 'uddi', 'password' => 'uddi' }
      end

      def fix
        @juddi.set_uri(@tfa_uri)
        @broken = false
      end

      def break
        @juddi.set_uri("http://127.0.0.1:9992")
        @broken = true
      end

      # ---- services ----

      def register_service(service)
        authorize
        return fail('no service identifier provided') if service.nil? or service['name'].nil?
        return fail('invalid service identifier provided') if ((not service.is_a? Hash) or (service['name'].strip == ""))
        registered = service_registered?(service['name'])
        return fail('service already exists') if (ServiceRegistry::Providers::JSendProvider::has_data?(registered) and registered['data']['registered'])
        result = @juddi.save_service(service['name'], service['description'], service['definition'])
        return fail('invalid service identifier provided') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_invalidKeyPassed')
        return fail('not authorized') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_authTokenRequired')
        success('service registered')

        rescue => ex
          fix if @broken
          fail('failure registering service')
      end

      def service_registered?(service)
        result = @juddi.find_services(service)
        registered = false
        if ServiceRegistry::Providers::JSendProvider::has_data?(result, 'services')
          result['data']['services'].each do |service_key, description|
            registered = (service.downcase == service_key.downcase)
          end
        end
        success_data({'registered' => registered})
      end

      def deregister_service(service)
        authorize
        return fail('no service identifier provided') if service.nil?
        return fail('invalid service identifier provided') if service.strip == ""
        registered = service_registered?(service)
        return success('unknown service') if not (ServiceRegistry::Providers::JSendProvider::has_data?(registered) and registered['data']['registered'])
        result = @juddi.delete_service(service)
        return fail('not authorized') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_authTokenRequired')
        return fail('invalid service identifier provided') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_invalidKeyPassed')
        success('service deregistered')

      rescue => ex
        fix if @broken
        fail('failure deregistering service')        
      end

      # ---- service definition ----

      def register_service_definition(service, definition)
        authorize       
        return fail('no service identifier provided') if service.nil?
        return fail('invalid service identifier provided') if (service.strip == "")
        registered = service_registered?(service)
        return success('unknown service identifier provided') if not (ServiceRegistry::Providers::JSendProvider::has_data?(registered) and registered['data']['registered'])
        return fail('no service definition provided') if definition.nil?
        return fail('invalid service definition provided') if not definition.include?("wadl")

        result = @juddi.get_service(service)
        service = result['data']
        service['definition'] = definition
        result = @juddi.save_service(service['name'], service['description'], service['definition'])
        return fail('not authorized') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_authTokenRequired')        
        return fail('invalid service identifier provided') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_invalidKeyPassed')
        success('service definition registered')
      rescue => ex
        fix if @broken
        fail('failure registering service definition')           
      end

      def service_definition_for_service(service)
        return fail('no service provided') if service.nil?
        return fail('invalid service identifier provided') if (service.strip == "")
        registered = service_registered?(service)
        return success('unknown service') if not (ServiceRegistry::Providers::JSendProvider::has_data?(registered) and registered['data']['registered'])
        result = @juddi.get_service(service)['data']
        return fail('invalid service identifier provided') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_invalidKeyPassed')
        return fail('service has no definition') if (result['definition'].nil?) or (result['definition'] == "")
        return success_data({'definition' => result['definition']}) if (not result.nil?) and (not result['definition'].nil?)
      end

      def deregister_service_definition(service)
        authorize
        return fail('no service provided') if service.nil?
        return fail('invalid service identifier provided') if (service.strip == "")
        registered = service_registered?(service)
        return success('unknown service') if not (ServiceRegistry::Providers::JSendProvider::has_data?(registered) and registered['data']['registered'])
        result = @juddi.get_service(service)
        service = result['data']
        service['definition'] = ""
        result = @juddi.save_service(service['name'], service['description'], service['definition'])
        return fail('not authorized') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_authTokenRequired')
        success('service definition deregistered')
      end

      # ---- domain perspectives ----      

      def reset_domain_perspectives
        authorize
        return if not @authorized
        result = list_domain_perspectives
        if ServiceRegistry::Providers::JSendProvider::has_data?(result, 'domain_perspectives') 
          result['data']['domain_perspectives'].each do |domain_perspective|
            @juddi.delete_business(domain_perspective)
          end
        end
      end

      def list_domain_perspectives
        result = @juddi.find_businesses
        result['data']['domain_perspectives'] = []

        if ServiceRegistry::Providers::JSendProvider::has_data?(result, 'businesses')
          result['data']['businesses'].each do |business, description|
            result['data']['domain_perspectives'] << business
          end
        end
        result
      end

      def domain_perspective_registered?(domain_perspective)
        result = @juddi.find_businesses(domain_perspective)
        registered = false
        if ServiceRegistry::Providers::JSendProvider::has_data?(result, 'businesses')
          result['data']['businesses'].each do |business, description|
            registered = (domain_perspective.downcase == business.downcase)
          end
        end
        success_data({'registered' => registered})
      end

      def register_domain_perspective(domain_perspective)
        authorize
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective') if (domain_perspective and domain_perspective.strip == "")
        registered = domain_perspective_registered?(domain_perspective)
        return fail('domain perspective already exists') if (ServiceRegistry::Providers::JSendProvider::has_data?(registered) and registered['data']['registered'])

        result = @juddi.save_business(domain_perspective)
        return fail('invalid domain perspective') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_invalidKeyPassed')
        return fail('not authorized') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_authTokenRequired')
        success('domain perspective registered')

      rescue => ex
        fix if @broken
        fail('failure registering domain perspective')     
      end

      def deregister_domain_perspective(domain_perspective)
        authorize
        return fail('no domain perspective provided') if domain_perspective.nil?
        return fail('invalid domain perspective provided') if domain_perspective.strip == ""

        registered = domain_perspective_registered?(domain_perspective)
        return fail('domain perspective unknown') if not (ServiceRegistry::Providers::JSendProvider::has_data?(registered) and registered['data']['registered'])
        # return fail('domain perspective has associations') if does_domain_perspective_have_service_components_associated?(domain_perspective)

        result = @juddi.delete_business(domain_perspective)
        return fail('not authorized') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_authTokenRequired')
        return fail('invalid domain perspective provided') if ServiceRegistry::Providers::JSendProvider::notifications_include?(result, 'E_invalidKeyPassed')
        success('domain perspective deregistered')

      rescue => ex
        fix if @broken
        fail('failure deregistering domain perspective')        
      end

      # ---- associations ----
      def associate_service_component_with_domain_perspective(domain_perspective, service_component)
      end

      def delete_domain_perspective_service_component_associations(domain_perspective)
      end

      private

      def authorize
        @juddi.authenticate(@credentials['username'], @credentials['password']) if @authorized
        @juddi.authenticate('', '') if not @authorized
      end
    end
  end
end
