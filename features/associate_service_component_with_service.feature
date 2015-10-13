Feature: Associate a service component with a service

  Scenario: No service component
    Given no service component
    And a valid service
    When I request association with the service
    Then I should receive a 'no service component provided' notification
    And the service associations should not change

  Scenario: No service
    Given no service
    And a valid service component
    When I request association of the service component
    Then I should receive a 'no service provided' notification
    And the service component associations should not change

  Scenario: Invalid service component
    Given invalid service component
    And a valid service
    When I request association of the service component with the service
    Then I should receive an 'invalid service component provided' notification
    And the service associations should not change

  Scenario: Invalid service
    Given invalid service
    And a valid service component
    When I request association of the service component with the service
    Then I should receive a 'no service provided' notification
    And the service associations should not change

  Scenario: valid service and service component associated
    Given a valid service
    And a valid service component
    When I request association of the service component with the service
    Then I should receive a 'success' notification
    And the service component should be associated with the service

  Scenario: failure
    Given a valid service
    And a valid service component
    And a failure
    When I request association of the service component with the service
    Then I should receive a 'failure associating service component with service' notification
    And the service associations should not change
