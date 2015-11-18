Feature: Configuring a URI for a service component
  As a provisioner
  When registering a service component
  In order to have the service component be accessible
  I want to configure a URI for the service component

  Scenario: Not authorized
    Given existing service component identifier
    And valid URI
    And unauthorized publisher
    When I request configuration of the service component
    Then I receive 'not authorized' notification

  Scenario: Providing a URI for a service component
    Given valid URI
    And existing service component identifier
    When I request configuration of the service component
    Then the service component should know about the URI

  Scenario: Invalid URI
    Given existing service component identifier
    And invalid URI
    When I request configuration of the service component
    Then I receive 'invalid URI' notification
    And the service component URI should remain unchanged

  Scenario: No URI
    Given existing service component identifier
    And no URI
    When I request configuration of the service component
    Then I receive 'no URI provided' notification
    And the service component URI should remain unchanged

  Scenario: No service component
    Given no service component identifier
    When I request configuration of the service component
    Then I receive 'no service component provided' notification

  Scenario: Invalid service component
    Given invalid service component identifier
    When I request configuration of the service component
    Then I receive 'invalid service component identifier' notification

  Scenario: Failure
    Given valid URI
    And existing service component identifier
    And a failure
    When I request configuration of the service component
    Then I receive 'failure configuring service component' notification
    And the service component URI should remain unchanged
