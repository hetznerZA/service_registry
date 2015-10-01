Feature: Registering domain perspectives
  As a developer
  When I have identified a new domain perspective
  In order to make the domain perspective available
  I want to register the domain perspective

  Scenario: No domain perspective
    Given no domain perspective
    When I request registration of the domain perspective
    Then I should receive a 'no domain perspective provided' notification
    And the domain perspective should not be available

  Scenario: New domain perspective
    Given a new domain perspective
    When I request registration of the domain perspective
    Then I should receive a 'domain perspective registered' notification
    And the domain perspective should be available

  Scenario: Existing domain perspective
    Given an existing domain perspective
    When I request registration of the domain perspective
    Then I should receive a 'domain perspective already exists' notification
    And the domain perspective should still be available

  Scenario: Invalid domain perspective
    Given an invalid domain perspective
    When I request registration of the domain perspective
    Then I should receive a 'invalid domain perspective' notification
    And the domain perspective should not be available

  Scenario: failure
    Given a domain perspective
    And any failure
    When I request registration of the domain perspective
    Then I should receive an error indicating 'failure registering domain perspective' 
    And the domain perspective should not be available
