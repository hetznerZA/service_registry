Feature: Removing URI from a service
  As a provisioner
  When deregistering a service
  In order to have the service no longer be accessible
  I want to remove a URI from the service

  Scenario: Not authorized
    Given a registered service
    And the service has URIs configured    
    And valid URI
    And unauthorized publisher
    When I request removal of a URI for the service
    Then I receive 'not authorized' notification

  Scenario: Removing a URI from a service
    Given a registered service
    And valid URI
    And the service has URIs configured
    When I request removal of a URI for the service
    Then the service should no longer know about the URI

  Scenario: Invalid URI
    Given a registered service
    And invalid URI
    And the service has URIs configured
    When I request removal of a URI for the service
    Then I receive 'invalid URI' notification
    And the service URIs should remain unchanged

  Scenario: No URI
    Given a registered service
    And no URI
    And the service has URIs configured
    When I request removal of a URI for the service
    Then I receive 'no URI provided' notification
    And the service URIs should remain unchanged

  Scenario: No service
    Given no service
    And valid URI
    When I request removal of a URI for the service
    Then I receive 'no service provided' notification

  Scenario: Invalid service
    Given invalid service identifier
    And valid URI
    When I request removal of a URI for the service
    Then I receive 'invalid service provided' notification

  Scenario: Failure
    Given a registered service
    And valid URI
    And the service has URIs configured
    And a failure
    When I request removal of a URI for the service
    Then I receive 'failure removing URI from service' notification
    And the service URIs should remain unchanged
