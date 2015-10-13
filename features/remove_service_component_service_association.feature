Feature: Removing service component associations from services
  As a provisioner
  Given a service component
  And a service
  When a service component should no longer be associated with a service
  In order to have the service component not be listed as associated with the service
  I want to deregister the service component from the service

  Scenario: invalid service
    Given an invalid service
    When I remove the service component association
    Then I receive an 'invalid service' notification

  Scenario: invalid service component
    Given an invalid service component
    When I remove the service component association
    Then I receive an 'invalid service component' notification

  Scenario: not associated
    Given a valid service component
    And a valid service
    And the service is not associated with the service component
    When I remove the service component association
    Then I receive a 'not associated' notification

  Scenario: associated
    Given a valid service component
    And a valid service
    And the service is associated with the service component
    When I remove the service component association
    Then I receive a 'success' notification
    And the service component is no longer associated with the service

