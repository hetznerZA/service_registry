Feature: Associate a service component with a domain perspective
  Scenario: Not authorized
    Given an existing domain perspective
    And existing service component identifier
    And unauthorized publisher
    When I request association of the service component with the domain perspective
    Then I receive 'not authorized' notification

  Scenario: No service component
    Given an existing domain perspective
    And no service component identifier
    When I request association of the service component with the domain perspective
    Then I receive 'no service component provided' notification
    And the domain perspective associations should not change

  Scenario: Invalid service component
    Given an existing domain perspective
    And invalid service component identifier
    When I request association of the service component with the domain perspective
    Then I receive 'invalid service component provided' notification
    And the domain perspective associations should not change

  Scenario: No domain perspective
    Given no domain perspective
    And existing service component identifier
    When I request association of the service component
    Then I receive 'no domain perspective provided' notification

  Scenario: Existing service component
    Given existing service component identifier
    And an existing domain perspective
    And the service component is already associated with the domain perspective
    When I request association of the service component with the domain perspective
    Then I receive 'already associated' notification
    And the domain perspective associations should not change

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    And existing service component identifier
    When I request association of the service component
    Then I receive 'invalid domain perspective provided' notification
    And the domain perspective associations should not change

  Scenario: valid domain perspective and service component associated
    Given an existing domain perspective
    And existing service component identifier
    When I request association of the service component
    Then I receive 'success' notification
    And the service component should be associated with the domain perspective

  Scenario: failure
    Given an existing domain perspective
    And existing service component identifier
    And a failure
    When I request association of the service component
    Then I receive 'failure associating service component with domain perspective' notification
    And the domain perspective associations should not change
