Given(/^one domain perspectives has been defined$/) do
  @test.define_one_domain_perspective
end

When(/^I request a list of domain perspectives$/) do
  @test.list_domain_perspectives
end

Then(/^I receive list containing the one domain perspective$/) do
  expect(@test.received_one_domain_perspective?).to eq(true)
end

Given(/^multiple domain perspectives have been defined$/) do
  @test.define_multiple_domain_perspectives
end

Then(/^I receive list containing the domain perspectives$/) do
  expect(@test.received_multiple_domain_perspectives?).to eq(true)
end

Given(/^no domain perspectives have been defined$/) do
  @test.clear_all_domain_perspectives
end

Then(/^I receive an empty list of domain perspectives$/) do
  expect(@test.received_an_empty_list_of_domain_perspectives?).to eq(true)
end

Given(/^domain perspectives have been defined$/) do
  @test.define_multiple_domain_perspectives
end

Given(/^an error condition prevents listing domain perspectives$/) do
  @test.break_registry
end

Then(/^I receive 'failure listing domain perspectives' notification$/) do
  expect(@test.has_received_notification?('failure listing domain perspectives')).to eq(true)
end

Given(/^no domain perspective$/) do
  @test.given_no_domain_perspective
end

When(/^I request registration of the domain perspective$/) do
  @test.register_domain_perspective
end

Then(/^I receive 'no domain perspective provided' notification$/) do
  expect(@test.has_received_notification?('no domain perspective provided')).to eq(true)
end

Then(/^the domain perspective should not be available$/) do
  expect(@test.is_domain_perspective_available?).to eq(false)
end

Given(/^a new domain perspective$/) do
  @test.given_a_new_domain_perspective
end

Then(/^I receive 'domain perspective registered' notification$/) do
  expect(@test.has_received_notification?('domain perspective registered')).to eq(true)
end

Then(/^the domain perspective should be available$/) do
  expect(@test.is_domain_perspective_available?).to eq(true)
end

Then(/^the team should be available$/) do
  expect(@test.is_team_available?).to eq(true)
end

Given(/^an existing domain perspective$/) do
  @test.given_an_existing_domain_perspective
end

Then(/^I receive 'domain perspective already exists' notification$/) do
  expect(@test.has_received_notification?('domain perspective already exists')).to eq(true)
end

Then(/^the domain perspective should still be available$/) do
  expect(@test.is_domain_perspective_available?).to eq(true)
end

Given(/^invalid domain perspective$/) do
  @test.given_an_invalid_domain_perspective
end

Then(/^I receive 'invalid domain perspective' notification$/) do
  expect(@test.has_received_notification?('invalid domain perspective')).to eq(true)
end

Given(/^a domain perspective$/) do
  @test.given_a_new_domain_perspective
end

Given(/^a failure$/) do
  @test.break_registry
end

Then(/^I receive 'failure registering domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure registering domain perspective')).to eq(true)
end

Given(/^an unknown domain perspective$/) do
  @test.given_unknown_domain_perspective
end

When(/^I request deregistration of the domain perspective$/) do
  @test.deregister_domain_perspective
end

Then(/^I receive 'domain perspective unknown' notification$/) do
  expect(@test.has_received_notification?('domain perspective unknown')).to eq(true)
end

Given(/^no service components associated with the domain perspective$/) do
  @test.given_no_service_components_associated_with_domain_perspective
end

Then(/^I receive 'domain perspective deregistered' notification$/) do
  expect(@test.has_received_notification?('domain perspective deregistered')).to eq(true)
end

Then(/^the domain perspective should no longer be available$/) do
  expect(@test.is_domain_perspective_available?).to eq(false)
end

Given(/^service components associated with the domain perspective$/) do
  @test.given_service_components_associated_with_domain_perspective
end

Then(/^I receive 'domain perspective has associations' notification$/) do
  expect(@test.has_received_notification?('domain perspective has associations')).to eq(true)
end

Then(/^I receive 'failure deregistering domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure deregistering domain perspective')).to eq(true)
end

Given(/^valid domain perspectives are one of \['domains', 'services', 'service\-components', team's\]$/) do
end

When(/^I request registration of a 'teams' domain perspective$/) do
  @test.register_team
end

When(/^I request registration of a 'domains' domain perspective$/) do
  @test.register_domain_perspective
end

Given(/^a new team$/) do
  @test.given_a_new_team
end

Given(/^the domain perspective has no associations$/) do
  @test.delete_all_domain_perspective_associations
end