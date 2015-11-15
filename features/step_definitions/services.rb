Given(/^unknown service identifier$/) do
  @test.given_unknown_service
end

Given(/^valid service definition$/) do
  @test.given_a_valid_service_definition
end

When(/^I register the service definition with the service$/) do
  @test.register_service_definition
end

Then(/^I receive 'unknown service identifier provided' notification$/) do
  expect(@test.has_received_notification?('unknown service identifier provided')).to eq(true)
end

Then(/^the service unavailable$/) do
  expect(@test.service_available?).to eq(false)
end

Given(/^a registered service$/) do
  @test.given_a_registered_service
end

Given(/^a valid service definition$/) do
  @test.given_a_valid_service_definition
end

Then(/^the service is described by the service definition$/) do
  expect(@test.is_service_described_by_service_definition?).to eq(true)
end

Then(/^I receive 'no service identifier provided' notification$/) do
  expect(@test.has_received_notification?('no service identifier provided')).to eq(true)
end

Then(/^I receive 'no service definition provided' notification$/) do
  expect(@test.has_received_notification?('no service definition provided')).to eq(true)
end

Then(/^I receive 'invalid service identifier provided' notification$/) do
  expect(@test.has_received_notification?('invalid service identifier provided')).to eq(true)
end

Given(/^no service definition$/) do
  @test.given_no_service_definition
end

Given(/^invalid service definition$/) do
  @test.given_invalid_service_definition
end

Then(/^I receive 'invalid service definition provided' notification$/) do
  expect(@test.has_received_notification?('invalid service definition provided')).to eq(true)
end

When(/^I deregister the service definition$/) do
  @test.deregister_service_definition
end

Then(/^the service is no longer described by the service definition$/) do
  expect(@test.is_service_described_by_service_definition?).to eq(false)
end

Given(/^the service definition describes the service$/) do
  @test.register_service_definition
end

When(/^I request the service definition$/) do
  @test.request_service_definition
end

Then(/^I receive the service definition$/) do
  expect(@test.has_received_service_definition?).to eq(true)
end

Then(/^I receive 'service has no definition' notification$/) do
  expect(@test.has_received_notification?('service has no definition')).to eq(true)
end

Given(/^a need$/) do
  @test.given_a_need
end

Given(/^no services match$/) do
  @test.no_services_match_need
end

When(/^I request a list of services that can meet my need$/) do
  @test.match_need
end

Then(/^I receive an empty list of services$/) do
  expect(@test.services_found?).to eq(false)
end

Given(/^one service match$/) do
  @test.provide_one_matching_service
end

Then(/^I receive a list of services with one entry$/) do
  expect(@test.single_service_match?).to eq(true)
end

Then(/^the entry should match my need$/) do
  expect(@test.entry_matches?).to eq(true)
end

Given(/^multiple service matches$/) do
  @test.provide_two_matching_services
end

Then(/^I receive a list of services with multiple entries$/) do
  expect(@test.multiple_services_match?).to eq(true)
end

Then(/^the entries should all match my need$/) do
  expect(@test.both_entries_match?).to eq(true)
end

Given(/^a service ID$/) do
  @test.given_a_valid_service
end

When(/^I request the service by ID$/) do
  @test.service_by_id
end

Then(/^I receive a list with the service as the single entry in it$/) do
  expect(@test.single_service_match?).to eq(true)
end

Given(/^no match for the service ID$/) do
  @test.given_unknown_service
end

Given(/^a pattern$/) do
  @test.given_a_pattern
end

Given(/^a service with the pattern in the ID$/) do
  @test.given_service_with_pattern_in_id
end

When(/^I request services matching the pattern$/) do
  @test.match_need
end

Then(/^I receive a list with the service included$/) do
  expect(@test.service_matched_pattern?).to eq(true)
end

Given(/^a service with the pattern in the description$/) do
  @test.given_service_with_pattern_in_description
end

Given(/^a service with the pattern in the service definition$/) do
  @test.given_service_with_pattern_in_definition
end

When(/^I request services matching the pattern in the domain perspective$/) do
  @test.match_pattern_in_domain_perspective
end

Given(/^multiple existing services$/) do
  @test.multiple_existing_services
end

Given(/^multiple existing service components$/) do
  @test.multiple_existing_service_components
end

Given(/^multiple existing domain perspectives$/) do
  @test.multiple_existing_domain_perspectives
end

Given(/^the service components registered in different domain perspectives$/) do
  @test.service_components_registered_in_different_domain_perspectives
end

Then(/^I receive a list of services matching the pattern$/) do
  expect(@test.matched_pattern_in_domain_perspectice?).to eq(true)
end

Then(/^all services in the list must be in the domain perspective$/) do
  expect(@test.matched_only_in_domain_perspective?).to eq(true)
end

Then(/^the service definition associated with the service remains unchanged$/) do
  expect(@test.service_definition_changed?).to eq(false)
end

Then(/^I receive 'failure registering service definition' notification$/) do
  expect(@test.has_received_notification?('failure registering service definition')).to eq(true)
end

When(/^I request registration of the service$/) do
  @test.register_service
end

Then(/^the service should not be available$/) do
  expect(@test.service_available?).to eq(false)
end

Given(/^a new service identifier$/) do
  @test.given_new_service
end

Then(/^I receive 'service registered' notification$/) do
  expect(@test.has_received_notification?('service registered')).to eq(true)
end

Then(/^the service should be available$/) do
  expect(@test.service_available?).to eq(true)
end

Then(/^I receive 'service already exists' notification$/) do
  expect(@test.has_received_notification?('service already exists')).to eq(true)
end

Then(/^the service should still be available, unchanged$/) do
  expect(@test.service_available?).to eq(true)
end

Then(/^I receive 'failure registering service' notification$/) do
  expect(@test.has_received_notification?('failure registering service')).to eq(true)
end

Given(/^invalid service for registration$/) do
  @test.given_invalid_service_for_registration
end

Given(/^an existing service identifier$/) do
  @test.given_existing_service_identifier
end

When(/^I request deregistration of the service$/) do
  @test.deregister_service
end

Then(/^I receive 'service unknown' notification$/) do
  expect(@test.has_received_notification?('unknown service')).to eq(true)
end

Then(/^I receive 'service deregistered' notification$/) do
  expect(@test.has_received_notification?('service deregistered')).to eq(true)
end

Then(/^I receive 'failure deregistering service' notification$/) do
  expect(@test.has_received_notification?('failure deregistering service')).to eq(true)
end

Given(/^no service definition associated with it$/) do
  @test.no_service_definition_associated
end

Then(/^I receive 'service definition deregistered' notification$/) do
  expect(@test.has_received_notification?('service definition deregistered')).to eq(true)
end

Then(/^I receive 'service definition registered' notification$/) do
  expect(@test.has_received_notification?('service definition registered')).to eq(true)
end

When(/^I request removal of a URI for the service$/) do
  @test.remove_uri_from_service
end

Then(/^the service should no longer know about the URI$/) do
  expect(@test.remember_uri?).to eq(false)
end

Then(/^I receive 'failure removing URI from service' notification$/) do
  expect(@test.has_received_notification?('failure removing URI from service')).to eq(true)
end

When(/^I request configuration of the service URI$/) do
  @test.configure_service_uri
end

Then(/^the service should know about the URI$/) do
  expect(@test.remember_uri?).to eq(true)
end

Then(/^the service URIs should remain unchanged$/) do
  expect(@test.service_uris_changed?).to eq(false)
end

Then(/^I receive 'failure configuring service' notification$/) do
  expect(@test.has_received_notification?('failure configuring service')).to eq(true)
end

When(/^I request a list of service URIs$/) do
  @test.request_service_uris
end

Given(/^the service has URIs configured$/) do
  @test.configure_some_service_uris
end

Then(/^I receive the list of URIs$/) do
  expect(@test.has_received_service_uris?).to eq(true)
end

Then(/^I receive 'failure listing service URIs' notification$/) do
  expect(@test.has_received_notification?('failure listing service URIs')).to eq(true)
end
