Feature: Associate a service component with a domain perspective

  Scenario: No service component
    Given no service component
    And a valid domain perspective
    When I request association with the domain perspective
    Then I should receive a 'no service component provided' notification
    And the domain perspective associations should not change

  Scenario: No domain perspective
    Given no domain perspective
    And a valid service component
    When I request association of the service component
    Then I should receive a 'no domain perspective provided' notification
    And the service component associations should not change

  Scenario: Invalid service component
    Given invalid service component
    And a valid domain perspective
    When I request association of the service component with the domain perspective
    Then I should receive an 'invalid service component provided' notification
    And the domain perspective associations should not change

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    And a valid service component
    When I request association of the service component with the domain perspective
    Then I should receive a 'no domain perspective provided' notification
    And the domain perspective associations should not change

  Scenario: valid domain perspective and service component associated
    Given a valid domain perspective
    And a valid service component
    When I request association of the service component with the domain perspective
    Then I should receive a 'success' notification
    And the service component should be associated with the domain perspective

  Scenario: failure
    Given a valid domain perspective
    And a valid service component
    And a failure
    When I request association of the service component with the domain perspective
    Then I should receive a 'failure associating service component with domain perspective' notification
    And the domain perspective associations should not change
