Feature: Associate a service component with a domain perspective

  Scenario: No service component
    Given no service component identifier
    And a domain perspective
    When I request association with the domain perspective
    Then I should receive a 'no service component provided' notification
    And the domain perspective associations should not change

  Scenario: Invalid service component
    Given invalid service component identifier
    And a domain perspective
    When I request association with the domain perspective
    Then I should receive a 'invalid service component identifier' notification
    And the domain perspective associations should not change

  Scenario: No domain perspective
    Given no domain perspective
    And an existing service component identifier
    When I request association of the service component
    Then I should receive a 'no domain perspective provided' notification
    And the service component associations should not change

  Scenario: Existing service component
    Given an existing service component identifier
    And a domain perspective
    And the service component is already associated with the domain perspective
    When I request association with the domain perspective
    Then I should receive an 'already associated' notification
    And the domain perspective associations should not change

  Scenario: Invalid domain perspective
    Given an invalid domain perspective
    And an existing service component identifier
    When I request association of the service component
    Then I should receive a 'invalid domain perspective provided' notification
    And the domain perspective associations should not change

  Scenario: valid domain perspective and service component associated
    Given a domain perspective
    And an existing service component identifier
    When I request association of the service component
    Then I should receive an 'association successful' notification
    And the service component should be associated with the domain perspective

  Scenario: failure
    Given a domain perspective
    And an existing service component identifier
    And a failure
    When I request association of the service component
    Then I should receive a 'failure associating service component with domain perspective' notification
    And the domain perspective associations should not change
