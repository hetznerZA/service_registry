When(/^I request registration of the service component$/) do
  @test.register_service_component
end

Then(/^the service component should not be available$/) do
  expect(@test.is_service_component_available?).to eq(false)
end

Then(/^I should receive a 'no service component identifier provided' notification$/) do
  expect(@test.has_received_notification?('no service component identifier provided')).to eq(true)
end

Given(/^a new service component identifier$/) do
  @test.given_new_service_component_identifier
end

Then(/^I should receive a 'service component registered' notification$/) do
  expect(@test.has_received_notification?('service component registered')).to eq(true)
end

Then(/^the service component should be available$/) do
  expect(@test.is_service_component_available?).to eq(true)
end

Given(/^an existing service component identifier$/) do
  @test.given_existing_service_component_identifier
end

Then(/^I should receive a 'service component already exists' notification$/) do
  expect(@test.has_received_notification?('service component already exists')).to eq(true)
end

Then(/^the service component should still be available, unchanged$/) do
  expect(@test.is_service_component_available?).to eq(true)
end

Given(/^invalid service component identifier$/) do
  @test.given_invalid_service_component_identifier
end

Given(/^no service component identifier$/) do
  @test.given_no_service_component_identifier
end

Then(/^I should receive a 'invalid service component identifier' notification$/) do
  expect(@test.has_received_notification?('invalid service component identifier')).to eq(true)
end

Then(/^I should receive an error indicating 'failure registering service component'$/) do
  expect(@test.has_received_notification?('failure registering service component')).to eq(true)
end

When(/^service components are listed$/) do
  @test.list_service_components
end

Given(/^no service components exist$/) do
  @test.given_no_service_components_exist
end

Then(/^I should receive an empty list$/) do
  expect(@test.received_no_service_components?).to eq(true)
end

Given(/^one or more service components exist$/) do
  @test.given_service_components_exist
end

Then(/^I should receive a list with all the service components$/) do
  expect(@test.received_list_of_all_service_components?).to eq(true)
end

Then(/^I should receive an error indicating 'failure retrieving service components'$/) do
  expect(@test.has_received_notification?('failure retrieving service components')).to eq(true)
end

Given(/^an unknown service component$/) do
  @test.given_unknown_service_component
end

When(/^I request deregistration of the service component$/) do
  @test.deregister_service_component
end

Then(/^I should receive a 'service component unknown' notification$/) do
  expect(@test.has_received_notification?('service component unknown')).to eq(true)
end

Given(/^no services associated with the service component$/) do
  @test.given_no_services_associated_with_service_component
end

Then(/^I should receive a 'service component deregistered' notification$/) do
  expect(@test.has_received_notification?('service component deregistered')).to eq(true)
end

Given(/^services associated with the service component$/) do
  @test.associate_services_with_service_component
end

Then(/^I should receive a 'service component has service associations' notification$/) do
  expect(@test.has_received_notification?('service component has service associations')).to eq(true)
end

Given(/^domain perspectives associated with the service component$/) do
  @test.associate_domain_perspective_with_service_component
end

Then(/^I should receive a 'service component has domain perspective associations' notification$/) do
  expect(@test.has_received_notification?('service component has domain perspective associations')).to eq(true)
end

Then(/^I should receive an error indicating 'failure deregistering service component'$/) do
  expect(@test.has_received_notification?('failure deregistering service component')).to eq(true)
end
