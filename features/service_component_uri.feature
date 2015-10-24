Feature: Configuring a URI for a service component
  As a provisioner
  When registering a service component
  In order to have the service component be accessible
  I want to configure a URI for the service component

  Scenario: Providing a URI for a service component
    Given valid URI
    And an existing service component
    When I request configuration of the service component with the URI
    Then the service component should know about the URI

  Scenario: Invalid URI
    Given invalid URI
    When I request configuration of the service component with the URI
    Then I receive 'invalid URI' notification
    And the service component URI should remain unchanged

  Scenario: Invalid service component
    Given invalid service component identifier
    When I request configuration of the service component
    Then I receive 'invalid service component' notification

  Scenario: Failure
    Given valid URI
    And an existing service component
    And a failure
    When I request configuration of the service component with the URI
    Then I receive 'failure configuring service component' notification
    And the service component URI should remain unchanged
