require "service_registry/version"

module ServiceRegistry
  HETZNER_BASE_URN = "uddi:hetzner.co.za" unless defined? HETZNER_BASE_URN; HETZNER_BASE_URN.freeze
  HETZNER_URN = "#{HETZNER_BASE_URN}:hetzner" unless defined? HETZNER_URN; HETZNER_URN.freeze
  HETZNER_DOMAINS_URN = "#{HETZNER_BASE_URN}:domain-" unless defined? HETZNER_DOMAINS_URN; HETZNER_DOMAINS_URN.freeze
  HETZNER_SERVICES_URN = "#{HETZNER_BASE_URN}:services" unless defined? HETZNER_SERVICES_URN; HETZNER_SERVICES_URN.freeze
  HETZNER_SERVICE_COMPONENTS_URN = "#{HETZNER_BASE_URN}:service-components" unless defined? HETZNER_SERVICE_COMPONENTS_URN; HETZNER_SERVICE_COMPONENTS_URN.freeze
end
