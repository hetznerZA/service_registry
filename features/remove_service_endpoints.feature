Feature: Removing URI from a service
  As a provisioner
  When deregistering a service
  In order to have the service no longer be accessible
  I want to remove a URI from the service

  Scenario: Not authorized
    Given a registered service
    And valid URI
    And unauthorized publisher
    When I request removal of a URI for the service
    Then I receive 'not authorized' notification

  Scenario: Removing a URI from a service
    Given valid URI
    Given a registered service
    When I request removal of a URI for the service
    Then the service should no longer about the URI

  Scenario: Invalid URI
    Given a registered service
    And invalid URI
    When I request removal of a URI for the service
    Then I receive 'invalid URI' notification
    And the service URIs should remain unchanged

  Scenario: No URI
    Given a registered service
    And no URI
    When I request removal of a URI for the service
    Then I receive 'no URI provided' notification
    And the service URIs should remain unchanged

  Scenario: No service
    Given no service identifier
    When I request removal of a URI for the service
    Then I receive 'no service provided' notification

  Scenario: Invalid service
    Given invalid service identifier
    When I request removal of a URI for the service
    Then I receive 'invalid service identifier' notification

  Scenario: Failure
    Given valid URI
    Given a registered service
    And a failure
    When I request removal of a URI for the service
    Then I receive 'failure removing URI from service' notification
    And the service URIs should remain unchanged
