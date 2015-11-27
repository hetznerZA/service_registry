Feature: Deregistering domain perspectives
  As a provisioner
  When a domain perspective is no longer in use
  In order to no longer have the domain perspective available
  I want to deregister the domain perspective

  Scenario: Not authorized
    Given an existing domain perspective    
    And the domain perspective has no associations
    And unauthorized publisher
    And the domain perspective has no associations
    When I request deregistration of the domain perspective
    Then I receive 'not authorized' notification

  Scenario: Unknown domain perspective
    Given an unknown domain perspective
    When I request deregistration of the domain perspective
    Then I receive 'unknown domain perspective' notification

  Scenario: Existing domain perspective
    Given an existing domain perspective
    And the domain perspective has no associations
    When I request deregistration of the domain perspective
    Then I receive 'domain perspective deregistered' notification
    And the domain perspective should no longer be available

  Scenario: Associated domain perspective
    Given an existing domain perspective
    And service components associated with the domain perspective
    When I request deregistration of the domain perspective
    Then I receive 'domain perspective has associations' notification
    And the domain perspective should be available

  Scenario: failure
    Given an existing domain perspective
    And the domain perspective has no associations
    And a failure
    When I request deregistration of the domain perspective
    Then I receive 'failure deregistering domain perspective' notification
    And the domain perspective should be available
