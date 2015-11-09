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
        @juddi.set_host(@tfa_uri)
        @broken = false
      end

      def break
        @juddi.set_uri("http://127.0.0.1:9992")
        @broken = true
      end

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
          fail('failure registering service')
      end

      def service_registered?(service)
        result = @juddi.find_services(service)
        registered = false
        if ServiceRegistry::Providers::JSendProvider::has_data?(result, 'services')
          result['data']['services'].each do |service_key, description|
            registered =  true if @juddi.service_eq?(service_key, service)
          end
        end
        success_data({'registered' => registered})

        rescue => ex
          return success_data({'registered' => false}) if (not @juddi.available?['available']) and @broken
          raise ex
      end

      def deregister_service(service)
        authorize
        result = @juddi.delete_service(service)
      end

      private

      def authorize
        @juddi.authenticate(@credentials['username'], @credentials['password']) if @authorized
        @juddi.authenticate('', '') if not @authorized
      end
    end
  end
end
