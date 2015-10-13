Feature: Removing service component associations from domain perspectives
  As a provisioner
  Given a service component
  And a domain perspective
  When a service component should no longer be associated with a domain perspective
  In order to have the service component not be listed as associated with the domain perspective
  I want to deregister the service component from the domain perspective

  Scenario: invalid domain perspective
    Given an invalid domain perspective
    When I remove the service component association
    Then I receive an 'invalid domain perspective' notification

  Scenario: invalid service component
    Given an invalid service component
    When I remove the service component association
    Then I receive an 'invalid service component' notification

  Scenario: not associated
    Given a valid service component
    And a valid domain perspective
    And the domain perspective is not associated with the service component
    When I remove the service component association
    Then I receive a 'not associated' notification

  Scenario: associated
    Given a valid service component
    And a valid domain perspective
    And the domain perspective is associated with the service component
    When I remove the service component association
    Then I receive a 'success' notification
    And the service component is no longer associated with the domain perspective

