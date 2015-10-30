Given(/^valid meta$/) do
  @test.given_valid_meta
end

Given(/^the service has meta configured$/) do
  @test.service_has_meta_configured
end

When(/^I request configuration of the service with meta$/) do
  @test.configure_service_meta
end

Then(/^the service should know about the meta$/) do
  expect(@test.meta_configured?).to eq(true)
end

Given(/^invalid meta$/) do
  @test.given_invalid_meta
end

Then(/^I receive 'invalid meta provided' notification$/) do
  expect(@test.has_received_notification?('invalid meta')).to eq(true)
end

Then(/^the service meta should remain unchanged$/) do
  expect(@test.meta_unchanged?).to eq(true)
end

Given(/^no meta$/) do
  @test.given_no_meta
end

Then(/^I receive 'no meta provided' notification$/) do
  expect(@test.has_received_notification?('no meta provided')).to eq(true)
end

Then(/^I receive 'failure configuring service with meta' notification$/) do
  expect(@test.has_received_notification?('failure configuring service with meta')).to eq(true)
end
