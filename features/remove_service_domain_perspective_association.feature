Feature: Removing service associations from domain perspectives
  As a provisioner
  Given a service
  And a domain perspective
  When a service should no longer be associated with a domain perspective
  In order to have the service not be listed as associated with the domain perspective
  I want to deregister the service from the domain perspective

  Scenario: Not authorized
    Given an existing domain perspective
    And a registered service
    And the service is already associated with the domain perspective
    And unauthorized publisher
    When I remove the service association from the domain perspective
    Then I receive 'not authorized' notification

  Scenario: no domain perspective
    Given a registered service
    And no domain perspective
    When I remove the service association from the domain perspective
    Then I receive 'no domain perspective provided' notification

  Scenario: invalid domain perspective
    Given a registered service
    And invalid domain perspective
    When I remove the service association from the domain perspective
    Then I receive 'invalid domain perspective provided' notification

  Scenario: no service
    Given an existing domain perspective
    And no service
    When I remove the service association from the domain perspective
    Then I receive 'no service provided' notification

  Scenario: invalid service
    Given an existing domain perspective
    And invalid service identifier
    When I remove the service association from the domain perspective
    Then I receive 'invalid service provided' notification

  Scenario: not associated
    Given a registered service
    And an existing domain perspective
    And the domain perspective is not associated with the service
    When I remove the service association from the domain perspective
    Then I receive 'not associated' notification

  Scenario: associated
    Given a registered service
    And an existing domain perspective
    And the service is already associated with the domain perspective
    When I remove the service association from the domain perspective
    Then I receive 'success' notification
    And the service is not associated with the domain perspective

  Scenario: failure
    Given a registered service
    And an existing domain perspective
    And the service is already associated with the domain perspective
    And a failure
    When I remove the service association from the domain perspective
    Then I receive 'failure disassociating service from domain perspective' notification
    And the domain perspective associations should not change

