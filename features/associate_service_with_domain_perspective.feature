Feature: Associate a service component with a domain perspective
  Scenario: Not authorized
    Given unauthorized publisher
    When I request association with the domain perspective
    Then I receive 'not authorized' notification

  Scenario: No service component
    Given no service component identifier
    And a domain perspective
    When I request association with the domain perspective
    Then I receive 'no service component provided' notification
    And the domain perspective associations should not change

  Scenario: Invalid service component
    Given invalid service component identifier
    And a domain perspective
    When I request association with the domain perspective
    Then I receive 'invalid service component identifier' notification
    And the domain perspective associations should not change

  Scenario: No domain perspective
    Given no domain perspective
    And existing service component identifier
    When I request association of the service component
    Then I receive 'no domain perspective provided' notification
    And the service component associations should not change

  Scenario: Existing service component
    Given existing service component identifier
    And a domain perspective
    And the service component is already associated with the domain perspective
    When I request association with the domain perspective
    Then I receive 'already associated' notification
    And the domain perspective associations should not change

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    And existing service component identifier
    When I request association of the service component
    Then I receive 'invalid domain perspective provided' notification
    And the domain perspective associations should not change

  Scenario: valid domain perspective and service component associated
    Given a domain perspective
    And existing service component identifier
    When I request association of the service component
    Then I receive 'success' notification
    And the service component should be associated with the domain perspective

  Scenario: failure
    Given a domain perspective
    And existing service component identifier
    And a failure
    When I request association of the service component
    Then I receive 'failure associating service component with domain perspective' notification
    And the domain perspective associations should not change
