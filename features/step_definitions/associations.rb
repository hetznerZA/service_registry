And (/^Some or no associations of service components with the domain perspective$/) do
  @test.given_some_or_no_associations_of_service_components_with_domain_perspective
end

When(/^I request association with the domain perspective$/) do
  @test.associate_domain_perspective_with_service_component
end

Then(/^I should receive a 'no service component provided' notification$/) do
  expect(@test.has_received_notification?('no service component provided')).to eq(true)
end

Then(/^the domain perspective associations should not change$/) do
  expect(@test.domain_perspective_associations_changed?).to eq(false)
end

Then(/^I should receive an 'existing service component provided' notification$/) do
  expect(@test.has_received_notification?('existing service component provided')).to eq(true)
end

When(/^I request association of the service component$/) do
  @test.associate_domain_perspective_with_service_component
end

Then(/^the service component associations should not change$/) do
  expect(@test.service_component_associations_changed?).to eq(false)
end

Then(/^I should receive an 'association successful' notification$/) do
  expect(@test.has_received_notification?('association successful')).to eq(true)
end

Then(/^the service component should be associated with the domain perspective$/) do
  expect(@test.is_service_component_associated_with_domain_perspective?).to eq(true)
end

Then(/^I should receive a 'failure associating service component with domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure associating service component with domain perspective')).to eq(true)
end

Given(/^the service component is already associated with the domain perspective$/) do
  @test.associate_domain_perspective_with_service_component
end

Then(/^I should receive an 'already associated' notification$/) do
  expect(@test.has_received_notification?('already associated')).to eq(true)
end

Then(/^I should receive a 'invalid domain perspective provided' notification$/) do
  expect(@test.has_received_notification?('invalid domain perspective provided')).to eq(true)
end
