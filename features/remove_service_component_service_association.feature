Feature: Removing service component associations from services
  As a provisioner
  Given a service component
  And a service
  When a service component should no longer be associated with a service
  In order to have the service component not be listed as associated with the service
  I want to deregister the service component from the service

  Scenario: no service
    Given existing service component identifier
    And no service
    When I remove the service association
    Then I receive 'no service provided' notification

  Scenario: invalid service
    Given existing service component identifier
    And invalid service identifier
    When I remove the service association
    Then I receive 'invalid service provided' notification

  Scenario: no service component
    Given no service component identifier
    When I remove the service association
    Then I receive 'no service component provided' notification

  Scenario: invalid service component
    Given invalid service component identifier
    When I remove the service association
    Then I receive 'invalid service component identifier' notification

  Scenario: not associated
    Given existing service component identifier
    And valid service
    And the service is not associated with the service component
    When I remove the service association
    Then I receive 'not associated' notification

  Scenario: associated
    Given existing service component identifier
    And valid service
    And the service is associated with the service component
    When I remove the service association
    Then I receive 'success' notification
    And the service component is no longer associated with the service

