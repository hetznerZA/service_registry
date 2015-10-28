Given(/^no configuration service bootstrap$/) do
  @test.given_no_configuration_service_bootstrap
end

Then(/^I need to present a 'no configuration service' notification$/) do
  expect(@test.has_received_notification?('no configuration service')).to eq(true)
end

Given(/^invalid configuration service bootstrap$/) do
  @test.given_invalid_configuration_service_bootstrap
end

Then(/^I need to present a 'invalid configuration service' notification$/) do
  expect(@test.has_received_notification?('invalid configuration service')).to eq(true)
end

Then(/^I should not be available$/) do
  expect(@test.service_registry_available?).to eq(false)
end

Given(/^a configuration service bootstrap$/) do
  @test.given_configuration_service_bootstrap
end

Given(/^a problem accessing the configuration service$/) do
  @test.given_configuration_service_inaccessible
end

When(/^I am initializing$/) do
  @test.initialize_service_registry
end

Then(/^I need to present a 'configuration error' notification$/) do
  expect(@test.has_received_notification?('configuration error')).to eq(true)
end

Given(/^no configuration stored in the configuration service$/) do
  @test.given_no_configuration_in_configuration_service
end

Given(/^an invalid configuration stored in the configuration service$/) do
  @test.given_invalid_configuration_in_configuration_service
end

Then(/^I need to present 'invalid configuration' notification$/) do
  expect(@test.has_received_notification?('invalid configuration')).to eq(true)
end

Then(/^I need to present 'no configuration' notification$/) do
  expect(@test.has_received_notification?('no configuration')).to eq(true)
end

Given(/^valid configuration in the configuration service$/) do
  @test.given_valid_configuration_in_configuration_service
end

Then(/^I need to present a 'configuration valid' notification$/) do
  expect(@test.has_received_notification?('configuration valid')).to eq(true)
end

Then(/^I should be available$/) do
  expect(@test.service_registry_available?).to eq(true)
end

Given(/^no identifier bootstrap$/) do
  @test.given_no_identifier_bootstrap
end

Then(/^I need to present a 'no identifier' notification$/) do
  expect(@test.has_received_notification?('no identifier')).to eq(true)
end

Given(/^invalid identifier bootstrap$/) do
  @test.given_invalid_identifier_bootstrap
end

Then(/^I need to present 'invalid identifier' notification$/) do
  expect(@test.has_received_notification?('invalid identifier')).to eq(true)
end

Given(/^valid identifier bootstrap$/) do
  @test.given_valid_identifier_bootstrap
end

Then(/^I need to present a 'valid identifier' notification$/) do
  expect(@test.has_received_notification?('valid identifier')).to eq(true)
end

