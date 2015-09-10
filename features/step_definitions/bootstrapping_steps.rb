Given(/^environmental service configuration$/) do
  @test.given_environmental_service_configuration
end

When(/^I bootstrap the configuration service from the environment$/) do
  @test.bootstrap_service_registry_environmentally
end

Then(/^I receive a functioning configuration service$/) do
  expect(@test.bootstrapped_service_registry_functional?).to eq true
end

Then(/^the environmental service configuration has been scrubbed$/) do
  expect(@test.environmental_service_configuration_scrubbed?).to eq true
end
