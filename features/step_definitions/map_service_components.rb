Then(/^I obtain a list of service components that provide that service$/) do
  expect(@test.has_list_of_service_components_providing_service?).to eq(true)
end

Then(/^I can extract a URI to the service on a service component$/) do
  @test.has_uri_to_service_component_providing_service?
end

Then(/^I can extract a status of the service component providing that service$/) do
  @test.has_status_of_service_component_providing_service?
end

Given(/^multiple service components provide the service$/) do
  @test.has_list_of_multiple_service_components_providing_service?
end

Then(/^I can extract all service components providing the service$/) do
  expect(@test.has_list_of_both_service_components_providing_service?).to eq(true)
end

Then(/^I receive an empty list of services components$/) do
  expect(@test.received_empty_list_of_service_components?)
end
