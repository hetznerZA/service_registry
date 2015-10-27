Feature: Associate a service component with a service

  Scenario: No service component
    Given no service component identifier
    And valid service
    When I request association with the service
    Then I receive 'no service component provided' notification
    And the service associations should not change

  Scenario: No service
    Given no service
    And existing service component identifier
    When I request association with the service
    Then I receive 'no service provided' notification
    And the service component associations should not change

  Scenario: Invalid service component
    Given invalid service component identifier
    And valid service
    When I request association with the service
    Then I receive 'invalid service component identifier' notification
    And the service associations should not change

  Scenario: Invalid service
    Given invalid service identifier
    And existing service component identifier
    When I request association with the service
    Then I receive 'invalid service provided' notification
    And the service associations should not change

  Scenario: valid service and service component associated
    Given valid service
    And existing service component identifier
    When I request association with the service
    Then I receive 'success' notification
    And the service component should be associated with the service

  Scenario: failure
    Given valid service
    And existing service component identifier
    And a failure
    When I request association with the service
    Then I receive 'failure associating service component with service' notification
    And the service associations should not change
