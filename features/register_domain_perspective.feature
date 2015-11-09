Feature: Registering domain perspectives
  As a provisioner
  When I have identified a new domain perspective
  In order to make the domain perspective available
  I want to register the domain perspective

  Scenario: Not authorized
    Given unauthorized publisher
    And a new domain perspective    
    When I request registration of the domain perspective
    Then I receive 'not authorized' notification

  Scenario: No domain perspective
    Given no domain perspective
    When I request registration of the domain perspective
    Then I receive 'no domain perspective provided' notification
    And the domain perspective should not be available

  Scenario: New domain perspective
    Given a new domain perspective
    When I request registration of the domain perspective
    Then I receive 'domain perspective registered' notification
    And the domain perspective should be available

  Scenario: Existing domain perspective
    Given an existing domain perspective
    When I request registration of the domain perspective
    Then I receive 'domain perspective already exists' notification
    And the domain perspective should still be available

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    When I request registration of the domain perspective
    Then I receive 'invalid domain perspective' notification
    And the domain perspective should not be available

  Scenario: failure
    Given a domain perspective
    And a failure
    When I request registration of the domain perspective
    Then I receive 'failure registering domain perspective' notification
    And the domain perspective should not be available
