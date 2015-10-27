Given(/^unknown service identifier$/) do
  @test.register_service_definition
  @test.given_unknown_service
end

Given(/^valid service definition$/) do
  @test.given_a_valid_service_definition
end

When(/^I register the service definition with the service$/) do
  @test.register_service_definition
end

Then(/^I receive 'unknown service identifier' notification$/) do
  expect(@test.has_received_notification?('unknown service identifier')).to eq(true)
end

Then(/^the service unavailable$/) do
  expect(@test.service_available?).to eq(false)
end

Given(/^an existing service identifier$/) do
  @test.given_a_valid_service
end

Given(/^a service definition$/) do
  @test.given_a_valid_service_definition
end

Then(/^the service is described by the service definition$/) do
  expect(@test.is_service_described_by_service_definition?).to eq(true)
end

Then(/^I receive 'no service identifier provided' notification$/) do
  expect(@test.has_received_notification?('no service identifier provided')).to eq(true)
end

Then(/^I receive 'invalid service identifier' notification$/) do
  expect(@test.has_received_notification?('invalid service identifier')).to eq(true)
end

Given(/^invalid service definition$/) do
  @test.given_invalid_service_definition
end

Then(/^I receive 'invalid service definition' notification$/) do
  expect(@test.has_received_notification?('invalid service definition')).to eq(true)
end

When(/^I deregister the service definition$/) do
  @test.deregister_service_definition
end

Then(/^the service is no longer described by the service definition$/) do
  expect(@test.is_service_described_by_service_definition?).to eq(false)
end

Given(/^it is described by a service definition$/) do
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

Then(/^I receive no services$/) do
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
