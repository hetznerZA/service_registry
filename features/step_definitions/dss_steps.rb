Given(/^a service with DSS meta$/) do
  @test.given_a_service_decorated_with_dss_meta
end

Given(/^the service is selected for a query result$/) do
  @test.select_service
end

Given(/^the DSS is unavailable$/) do
  @test.make_dss_unavailable
end

When(/^a service query is performed$/) do
  @test.query_a_service
end

Then(/^the service registry should not include the service in the result$/) do
  expect(@test.service_included_in_results?).to eq(false)
end

Given(/^the DSS indicates the service should be included in the results$/) do
  @test.given_dss_indicates_service_inclusion
end

Then(/^the service registry should include the service in the result$/) do
  pending
  #expect(@test.service_included_in_results?).to eq(true)
end

Given(/^the DSS indicates the service should not be included in the results$/) do
  @test.given_dss_indicates_service_exclusion
end

Given(/^the DSS indicates the service is not known to it$/) do
  @test.given_dss_indicates_service_not_known
end

Given(/^the DSS indicates an error in attempting to determine inclusion for the service$/) do
  @test.given_dss_error_indication
end
