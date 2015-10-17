Feature: Deregistering domain perspectives
  As a provisioner
  When a domain perspective is no longer in use
  In order to no longer have the domain perspective available
  I want to deregister the domain perspective

  Scenario: Unknown domain perspective
    Given an unknown domain perspective
    When I request deregistration of the domain perspective
    Then I should receive a 'domain perspective unknown' notification

  Scenario: Existing domain perspective
    Given an existing domain perspective
    And no service components associated with the domain perspective
    When I request deregistration of the domain perspective
    Then I should receive a 'domain perspective deregistered' notification
    And the domain perspective should no longer be available

  Scenario: Associated domain perspective
    Given a domain perspective
    And service components associated with the domain perspective
    When I request deregistration of the domain perspective
    Then I should receive a 'domain perspective has associations' notification
    And the domain perspective should be available

  Scenario: failure
    Given an existing domain perspective
    And no service components associated with the domain perspective
    And a failure
    When I request deregistration of the domain perspective
    Then I should receive an error indicating 'failure dregistering domain perspective' 
    And the domain perspective should be available