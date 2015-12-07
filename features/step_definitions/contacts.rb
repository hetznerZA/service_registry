When(/^I request contact details for the domain perspective$/) do
  @test.request_contact_details_for_domain_perspective
end

Given(/^no contact details for the domain perspective$/) do
  @test.no_contact_details_for_domain_perspective
end

Given(/^one contact for the domain perspective$/) do
  @test.one_contact_for_domain_perspective
end

Given(/^multiple contacts for the domain perspective$/) do
  @test.multiple_contacts_for_domain_perspective
end

Then(/^I receive an empty list of contacts$/) do
  expect(@test.has_received_empty_list_of_contacts?).to eq(true)
end

Then(/^I receive a list with the contact$/) do
  expect(@test.has_received_list_with_one_contact?).to eq(true)
end

Then(/^I receive a list of all the contacts$/) do
  expect(@test.has_received_list_with_all_contacts?).to eq(true)
end

Then(/^I receive 'failure retrieving contact details' notification$/) do
  expect(@test.has_received_notification?('failure retrieving contact details')).to eq(true)
end

When(/^I add the contact to the domain perspective$/) do
  @test.add_contact_to_domain_perspective
end

Given(/^invalid contact details$/) do
  @test.given_invalid_contact_details
end

Then(/^I receive 'no contact details provided' notification$/) do
  @test.given_no_contact_details
end

Then(/^I receive 'invalid contact details provided' notification$/) do
  expect(@test.has_received_notification?('invalid contact details provided')).to eq(true)
end

Given(/^existing contact name$/) do
  @test.given_existing_contact
end

Given(/^valid contact details$/) do
	@test.given_valid_contact_details
end

Then(/^I receive 'contact already exists \- remove first to update' notification$/) do
  expect(@test.has_received_notification?('contact already exists - remove first to update')).to eq(true)
end

Then(/^the contact is associated with the domain perspective$/) do
  expect(@test.contact_associated_with_domain_perspective?).to eq(true)
end

Then(/^I receive 'failure adding contact' notification$/) do
  expect(@test.has_received_notification?('failure adding contact')).to eq(true)
end

When(/^I remove the contact from the domain perspective$/) do
  @test.remove_contact_from_domain_perspective
end

Then(/^the contact is no longer associated with the domain perspective$/) do
  expect(@test.contact_associated_with_domain_perspective?).to eq(false)
end

Then(/^I receive 'unknown contact' notification$/) do
  expect(@test.has_received_notification?('unknown contact')).to eq(true)
end

Then(/^I receive 'failure removing contact' notification$/) do
  expect(@test.has_received_notification?('failure removing contact')).to eq(true)
end