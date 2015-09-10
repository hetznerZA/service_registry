Given(/^an identifier$/) do
end

Given(/^some configuration data$/) do
end

When(/^I request publication of the configuration data$/) do
  @test.authorize(:publishing_configurations)
  @test.publish_configuration
end

Then(/^I receive a unique revision for my publication$/) do
  expect(@test.published_revision).to_not be_nil
end

Then(/^the metadata is updated with the revision by the CS$/) do
  expect(@test.published_metadata).to include("revision" => @test.published_revision)
end

Given(/^some metadata$/) do
  @test.given_metadata
end

Then(/^the metadata is also remembered$/) do
  expect(@test.published_metadata).to include(@test.given_metadata)
end

Then(/^the entry is timestamped$/) do
  expect(@test.published_metadata).to include("timestamp")
end

Given(/^existing configuration data$/) do
  @test.given_existing_configuration
end

When(/^I request publication of configuration data using the existing identifier$/) do
  @test.authorize(:publishing_configurations)
  @test.publish_configuration
end

Then(/^I receive a new unique revision for the publication$/) do
  expect(@test.published_revision).to_not eq @test.existing_revision
end

Given(/^invalid configuration data$/) do
  @test.given_invalid_configuration
end

Then(/^I receive an 'invalid data' notification$/) do
  expect(@test.request_failed?).to eq true
end

Given(/^a CS publication failure$/) do
  @test.given_publication_failure
end

Then(/^I should receive a 'publication failure' notification$/) do
  expect(@test.request_failed?).to eq true
end

