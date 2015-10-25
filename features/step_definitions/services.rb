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
