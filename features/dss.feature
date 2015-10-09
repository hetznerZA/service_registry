Feature: Querying a decision support system
  As a service registry
  When a service requested has meta indicating a DSS should be queried
  Given a DSS
  And query details
  And a service
  In order to decide whether to include the service in a query result
  I want ask the DSS

  Scenario: DSS unavailable
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS is unavailable
    When a service query is performed
    Then the service registry should not include the service in the result

  Scenario: DSS indicates inclusion
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates the service should be included in the results
    When a service query is performed
    Then the service registry should include the service in the result

  Scenario: DSS indicates exclusion
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates the service should not be included in the results
    When a service query is performed
    Then the service registry should not include the service in the result

  Scenario: DSS indicates no match
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates the service is not known to it
    When a service query is performed
    Then the service registry should not include the service in the result

  Scenario: DSS indicates failure
    Given a service with DSS meta
    And the service is selected for a query result
    And the DSS indicates an error in attempting to determine inclusion for the service
    When a service query is performed
    Then the service registry should not include the service in the result

