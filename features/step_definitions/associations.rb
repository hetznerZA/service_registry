And (/^Some or no associations of service components with the domain perspective$/) do
  @test.given_some_or_no_associations_of_service_components_with_domain_perspective
end

When(/^I request association with the domain perspective$/) do
  @test.associate_domain_perspective_with_service_component
end

Then(/^I receive 'no service component provided' notification$/) do
  expect(@test.has_received_notification?('no service component provided')).to eq(true)
end

Then(/^the domain perspective associations should not change$/) do
  expect(@test.domain_perspective_associations_changed?).to eq(false)
end

Then(/^I receive 'existing service component provided' notification$/) do
  expect(@test.has_received_notification?('existing service component provided')).to eq(true)
end

When(/^I request association of the service component$/) do
  @test.associate_domain_perspective_with_service_component
end

Then(/^the service component associations should not change$/) do
  expect(@test.service_component_associations_changed?).to eq(false)
end

Then(/^I receive 'success' notification$/) do
  expect(@test.has_received_notification?('success')).to eq(true)
end

Then(/^the service component should be associated with the domain perspective$/) do
  expect(@test.is_service_component_associated_with_domain_perspective?).to eq(true)
end

Then(/^I receive 'failure associating service component with domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure associating service component with domain perspective')).to eq(true)
end

Given(/^the service component is already associated with the domain perspective$/) do
  @test.associate_domain_perspective_with_service_component
end

Then(/^I receive 'already associated' notification$/) do
  expect(@test.has_received_notification?('already associated')).to eq(true)
end

Then(/^I receive 'invalid domain perspective provided' notification$/) do
  expect(@test.has_received_notification?('invalid domain perspective provided')).to eq(true)
end

Given(/^valid service$/) do
  @test.given_a_valid_service
end

When(/^I request association with the service$/) do
  @test.associate_service_with_service_component
end

Then(/^the service associations should not change$/) do
  expect(@test.service_component_associations_changed?).to eq(false)
end

Given(/^no service$/) do
  @test.given_no_service
end

Then(/^I receive 'no service provided' notification$/) do
  expect(@test.has_received_notification?('no service provided')).to eq(true)
end

Given(/^invalid service identifier$/) do
  @test.given_invalid_service
end

Then(/^the service component should be associated with the service$/) do
  expect(@test.is_service_component_associated_with_service?).to eq(true)
end

Given(/^the service is associated with two service components$/) do
  @test.associate_service_with_two_service_components
end

Then(/^I receive 'failure associating service component with service' notification$/) do
  expect(@test.has_received_notification?('failure associating service component with service')).to eq(true)
end

Then(/^I receive 'invalid service provided' notification$/) do
  expect(@test.has_received_notification?('invalid service provided')).to eq(true)
end

When(/^I remove the service component association$/) do
  @test.disassociate_domain_perspective_from_service_component
end

Given(/^the domain perspective is not associated with the service component$/) do
  expect(@test.is_service_component_associated_with_domain_perspective?).to eq(false)
end

Then(/^I receive 'not associated' notification$/) do
  expect(@test.has_received_notification?('not associated')).to eq(true)
end

Then(/^the service component is no longer associated with the domain perspective$/) do
  expect(@test.is_service_component_associated_with_domain_perspective?).to eq(false)
end

Given(/^the service is not associated with the service component$/) do
end

Given(/^the service is associated with the service component$/) do
  @test.associate_service_with_service_component
end

Then(/^the service component is no longer associated with the service$/) do
  expect(@test.is_service_component_associated_with_service?).to eq(false)
end

When(/^I remove the service association$/) do
  @test.disassociate_service_from_service_component
end
