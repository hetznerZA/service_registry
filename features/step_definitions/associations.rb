Given(/^unauthorized publisher$/) do
  @test.unauthorized
end

Then(/^I receive 'not authorized' notification$/) do
  expect(@test.has_received_notification?('not authorized')).to eq(true)
end

And (/^Some or no associations of service components with the domain perspective$/) do
  @test.given_some_or_no_associations_of_service_components_with_domain_perspective
end

When(/^I request association of the service component with the domain perspective$/) do
  @test.associate_domain_perspective_with_service_component
end

When(/^I request association of the service with the domain perspective$/) do
  @test.associate_domain_perspective_with_service
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

Then(/^the service should be associated with the domain perspective$/) do
  expect(@test.is_service_associated_with_domain_perspective?).to eq(true)
end

Then(/^I receive 'failure associating service component with domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure associating service component with domain perspective')).to eq(true)
end

Then(/^I receive 'failure associating service with domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure associating service with domain perspective')).to eq(true)
end


Given(/^the service component is already associated with the domain perspective$/) do
  @test.associate_domain_perspective_with_service_component
end

Given(/^the service is already associated with the domain perspective$/) do
  @test.associate_domain_perspective_with_service
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

Given(/^no service$/) do
  @test.given_no_service
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

When(/^I remove the service component association from the domain perspective$/) do
  @test.disassociate_domain_perspective_from_service_component
end

When(/^I remove the service association from the domain perspective$/) do
  @test.disassociate_domain_perspective_from_service
end

Given(/^the domain perspective is not associated with the service component$/) do
  @test.disassociate_domain_perspective_from_service_component
end

Given(/^the domain perspective is not associated with the service$/) do
  @test.disassociate_domain_perspective_from_service
end

Then(/^I receive 'not associated' notification$/) do
  expect(@test.has_received_notification?('not associated')).to eq(true)
end

Then(/^I receive 'failure disassociating service component from domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure disassociating service component from domain perspective')).to eq(true)
end

Then(/^the service component is no longer associated with the domain perspective$/) do
  expect(@test.is_service_component_associated_with_domain_perspective?).to eq(false)
end

Given(/^the service is not associated with the domain perspective$/) do
end

Given(/^the service is associated with the service component$/) do
  @test.associate_service_with_service_component
end

Given(/^the service is not associated with any service components$/) do
  # do nothing, by default not associated
end

Then(/^I receive 'failure disassociating service from domain perspective' notification$/) do
  expect(@test.has_received_notification?('failure disassociating service from domain perspective')).to eq(true)
end

Given(/^no service associations$/) do
  @test.no_service_associations
end

When(/^I request associations for the service$/) do
  @test.request_associations_for_service
end

Then(/^I receive an empty association dictionary$/) do
  expect(@test.received_an_empty_dictionary_of_service_associations).to eq(true)
end

Then(/^I receive an association dictionary with the domain perspective associations$/) do
  expect(@test.received_associations_dictionary_with_domain_perspective_associations).to eq(true)
end

Then(/^I receive an association dictionary with the service component URIs$/) do
  expect(@test.received_associations_dictionary_with_service_component_uris).to eq(true)
end

Then(/^I receive 'failure determining associations for service' notification$/) do
  expect(@test.has_received_notification?('failure determining associations for service')).to eq(true)
end

