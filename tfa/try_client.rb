require '../lib/service_registry/providers/jsend_provider.rb'
require '../lib/service_registry/providers/juddi_provider.rb'

iut = ServiceRegistry::Providers::JUDDIProvider.new
iut.authenticate('root', 'root')

test = 1

if test == 1
  result = iut.save_service('temporary', 'A temporary service', 'http://github.com/temp/one.wadl')
byebug
  result = iut.save_bindings('temporary', ['http://sc1.dev.auto-h/net/temporary', 'http://sc2.dev.auto-h/net/temporary'])
  sleep 10
  ##check in juddi

  service = iut.get_service('temporary')

  puts service

  #services = iut.find_services['data']['services']
  #puts services

  services = iut.find_services('empo')['data']['services']
  #puts services

  result = iut.delete_service('temporary')
  puts result
end

if test == 2
  result = iut.save_business('billing')
  sleep 10
  ##check in juddi
  result = iut.find_businesses
  puts result

  businesses = iut.find_businesses('billing')['data']['businesses']
  businesses.each do |id, name|
    @business = id if name == 'billing'
  end

  result = iut.delete_business(@business)
  puts result
end
