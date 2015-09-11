Feature: Querying a decision support system
  As a decision support system
  When a service requested has been tagged with meta indicating a DSS should be queried
  And that service is selected for a query result
  In order to provide a decision about whether to include the service in the query result
  I want to be queried by the service registry with the service and query details

  Scenario: DSS unavailable
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS is unavailable
    Then the service registry should not include the service in the result

  Scenario: DSS indicates inclusion
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates the service should be included in the results
    Then the service registry should include the service in the result

  Scenario: DSS indicates exclusion
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates the service should not be included in the results
    Then the service registry should not include the service in the result

  Scenario: DSS indicates no match
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates the service is not known to it
    Then the service registry should not include the service in the result

  Scenario: DSS indicates failure
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates an error in attempting to determine inclusion for the service
    Then the service registry should not include the service in the result

