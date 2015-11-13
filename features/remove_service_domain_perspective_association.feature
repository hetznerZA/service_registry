Feature: Removing service component associations from domain perspectives
  As a provisioner
  Given a service component
  And a domain perspective
  When a service component should no longer be associated with a domain perspective
  In order to have the service component not be listed as associated with the domain perspective
  I want to deregister the service component from the domain perspective

  Scenario: Not authorized
    Given existing service component identifier
    And an existing domain perspective
    And unauthorized publisher
    When I remove the service component association
    Then I receive 'not authorized' notification

  Scenario: no domain perspective
    Given existing service component identifier
    And no domain perspective
    When I remove the service component association
    Then I receive 'no domain perspective provided' notification

  Scenario: invalid domain perspective
    Given existing service component identifier
    And invalid domain perspective
    When I remove the service component association
    Then I receive 'invalid domain perspective provided' notification

  Scenario: no service component
    Given no service component identifier
    And an existing domain perspective
    When I remove the service component association
    Then I receive 'no service component provided' notification

  Scenario: invalid service component
    Given invalid service component identifier
    And an existing domain perspective
    When I remove the service component association
    Then I receive 'invalid service component identifier' notification

  Scenario: not associated
    Given existing service component identifier
    And an existing domain perspective
    And the domain perspective is not associated with the service component
    When I remove the service component association
    Then I receive 'not associated' notification

  Scenario: associated
    Given existing service component identifier
    And an existing domain perspective
    And the service component is already associated with the domain perspective
    When I remove the service component association
    Then I receive 'success' notification
    And the service component is no longer associated with the domain perspective

  Scenario: failure
    Given existing service component identifier
    And an existing domain perspective
    And the service component is already associated with the domain perspective
    And a failure
    When I remove the service component association
    Then I receive 'failure disassociating service from domain perspective' notification
    And the domain perspective associations should not change
