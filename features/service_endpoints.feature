Feature: Configuring URI for a service
  As a provisioner
  When registering a service
  In order to have the service accessible
  I want to configure a URI for the service

  Scenario: Not authorized
    Given a registered service
    And valid URI
    And unauthorized publisher
    When I request configuration of the service URI
    Then I receive 'not authorized' notification

  Scenario: Providing a URI for a service
    Given valid URI
    Given a registered service
    When I request configuration of the service URI
    Then the service should know about the URI

  Scenario: Invalid URI
    Given a registered service
    And invalid URI
    When I request configuration of the service URI
    Then I receive 'invalid URI' notification
    And the service URI should remain unchanged

  Scenario: No URI
    Given a registered service
    And no URI
    When I request configuration of the service URI
    Then I receive 'no URI provided' notification
    And the service URI should remain unchanged

  Scenario: No service
    Given no service identifier
    When I request configuration of the service URI
    Then I receive 'no service provided' notification

  Scenario: Invalid service
    Given invalid service identifier
    When I request configuration of the service URI
    Then I receive 'invalid service identifier' notification

  Scenario: Failure
    Given valid URI
    Given a registered service
    And a failure
    When I request configuration of the service URI
    Then I receive 'failure configuring service' notification
    And the service URI should remain unchanged
