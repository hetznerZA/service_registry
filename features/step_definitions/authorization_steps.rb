Given(/^I have no credentials$/) do
  pending "Use case supported by Vault command-line client"
end

When(/^I request a token$/) do
  pending "Use case supported by Vault command-line client"
end

Then(/^I should not receive a token$/) do
  pending "Use case supported by Vault command-line client"
end

Given(/^I have invalid credentials$/) do
  pending "Use case supported by Vault command-line client"
end

Given(/^I have valid credentials$/) do
  pending "Use case supported by Vault command-line client"
end

Then(/^I should receive a token$/) do
  pending "Use case supported by Vault command-line client"
end

Given(/^I do not have a token$/) do
  @test.deauthorize
end

Given(/^I have a token that allows requesting configurations$/) do
  @test.authorize(:requesting_configurations)
end

When(/^I request a configuration$/) do
  @test.request_configuration
end

Then(/^I should be allowed to request configurations$/) do
  expect(@test.request_allowed?).to eq true
end

Given(/^I have a token that does not allow requesting configurations$/) do
  @test.authorize(:nothing)
end

Then(/^I should be notified that my request is 'not authorized'$/) do
  expect(@test.request_allowed?).to eq false
end

Given(/^I have a token that allows publishing configurations$/) do
  @test.authorize(:publishing_configurations)
end

When(/^I request publication of a configuration$/) do
  @test.publish_configuration
end

Then(/^I should be allowed to publish configurations$/) do
  expect(@test.request_allowed?).to eq true
end

Given(/^I have a token that does not allow publishing configurations$/) do
  @test.authorize(:requesting_configurations)
end
