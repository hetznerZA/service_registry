Feature: Standardizing names
  As an architect
  When I am deploying a service registry
  In order to ensure no issues with naming
  I want all names to be lowercase

  Scenario: New service
    Given a new service identifier in uppercase
    When I request registration of the service
    Then I receive 'service registered' notification
    And the service should be available using the standardized lowercase name
