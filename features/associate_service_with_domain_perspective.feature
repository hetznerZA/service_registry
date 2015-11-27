Feature: Associate a service with a domain perspective
  Scenario: Not authorized
    Given an existing domain perspective
    And a registered service
    And unauthorized publisher
    When I request association of the service with the domain perspective
    Then I receive 'not authorized' notification

  Scenario: No service
    Given an existing domain perspective
    And no service
    When I request association of the service with the domain perspective
    Then I receive 'no service provided' notification
    And the domain perspective associations should not change

  Scenario: Invalid service
    Given an existing domain perspective
    And invalid service identifier
    When I request association of the service with the domain perspective
    Then I receive 'invalid service provided' notification
    And the domain perspective associations should not change

  Scenario: No domain perspective
    Given no domain perspective
    And a registered service
    When I request association of the service with the domain perspective
    Then I receive 'no domain perspective provided' notification

  Scenario: Existing service
    Given a registered service
    And an existing domain perspective
    And the service is already associated with the domain perspective
    When I request association of the service with the domain perspective
    Then I receive 'already associated' notification
    And the domain perspective associations should not change

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    And a registered service
    When I request association of the service with the domain perspective
    Then I receive 'invalid domain perspective provided' notification
    And the domain perspective associations should not change

  Scenario: valid domain perspective and service associated
    Given an existing domain perspective
    And a registered service
    When I request association of the service with the domain perspective
    Then I receive 'success' notification
    And the service should be associated with the domain perspective

  Scenario: failure
    Given an existing domain perspective
    And a registered service
    And a failure
    When I request association of the service with the domain perspective
    Then I receive 'failure associating service with domain perspective' notification
    And the domain perspective associations should not change
