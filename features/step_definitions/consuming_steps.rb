Given(/^a metadata filter$/) do
  pending "Searching with metadata filters not yet supported"
end

Then(/^I should receive a 'no match' indication$/) do
  expect(@test.request_not_matched?).to eq true
end

Then(/^the configuration data should be returned for the identifier$/) do
  expect(@test.configuration_found_for_identifier?).to eq true
end

Given(/^no meta data filter$/) do
end

Given(/^configuration data at the index is present$/) do
  @test.given_existing_configuration
end

When(/^I request configuration data$/) do
  @test.authorize(:requesting_configurations)
  @test.request_configuration
end

Then(/^the configuration data should be returned for the index and meta data filter$/) do
  pending "Searching with metadata filters not yet supported"
end

Given(/^configuration data at the index is not present$/) do
  @test.given_missing_configuration
end

Then(/^I should receive a 'not found' indication$/) do
  expect(@test.request_not_found?).to eq true
end

Given(/^only one entry of configuration data matching the meta data filter is present$/) do
  pending "Identifier-free requests not supported"
end

Then(/^the configuration data should be returned for the index and meta data filter as the only item$/) do
  pending "Identifier-free requests not supported"
end

Given(/^multiple entries of configuration data matching the meta data filter are present$/) do
  pending "Identifier-free requests not supported"
end

Then(/^all matching configuration data should be returned$/) do
  pending "Identifier-free requests not supported"
end

Given(/^no entry matching the meta data filter is present$/) do
  pending "Identifier-free requests not supported"
end

Given(/^a CS request failure$/) do
  @test.given_request_failure
end

Then(/^I should receive a 'request failure' notification$/) do
  expect(@test.request_failed?).to eq true
end
