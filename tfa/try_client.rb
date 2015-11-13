require '../lib/service_registry/providers/jsend_provider.rb'
require '../lib/service_registry/providers/juddi_provider.rb'

HETZNER_BASE_URN = "uddi:hetzner.co.za" unless defined? HETZNER_BASE_URN; HETZNER_BASE_URN.freeze
HETZNER_URN = "#{HETZNER_BASE_URN}:hetzner" unless defined? HETZNER_URN; HETZNER_URN.freeze
HETZNER_DOMAINS_URN = "#{HETZNER_BASE_URN}:domain-" unless defined? HETZNER_DOMAINS_URN; HETZNER_DOMAINS_URN.freeze
HETZNER_SERVICES_URN = "#{HETZNER_BASE_URN}:services" unless defined? HETZNER_SERVICES_URN; HETZNER_SERVICES_URN.freeze
HETZNER_SERVICE_COMPONENTS_URN = "#{HETZNER_BASE_URN}:service-components" unless defined? HETZNER_SERVICE_COMPONENTS_URN; HETZNER_SERVICE_COMPONENTS_URN.freeze
urns = { 'base' => HETZNER_BASE_URN,
                 'company' => HETZNER_URN,
                 'domains' => HETZNER_DOMAINS_URN,
                 'services' => HETZNER_SERVICES_URN,
                 'service-components' => HETZNER_SERVICE_COMPONENTS_URN}
iut = ServiceRegistry::Providers::JUDDIProvider.new(urns)
iut.set_uri("http://localhost:8080")
iut.authenticate('uddi', 'uddi')

#result = iut.save_business('billing')
#result = iut.save_service('temporary', 'A temporary service', 'http://github.com/temp/one.wadl')
result = iut.find_businesses
puts result
