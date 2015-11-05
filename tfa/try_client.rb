require '../lib/service_registry/providers/jsend_provider.rb'
require '../lib/service_registry/providers/juddi_provider.rb'

iut = ServiceRegistry::Providers::JUDDIProvider.new
result = iut.register_service("temporary")
services = iut.query_service_by_pattern('empo')['data']['services']
services.each do |id, name|
  @service = id if name == "temporary"
end
result = iut.deregister_service(@service)

puts result
