Feature: Configuring a URI for a service component
  As a provisioner
  When registering a service component
  In order to have the service component be accessible
  I want to configure a URI for the service component

  Scenario: Providing a URI for a service component
    Given a valid URI
    And an existing service component
    When I request configuration of the service component with the URI
    Then the service component should know about the URI

  Scenario: Invalid URI
    Given an invalid URI
    When I request configuration of the service component with the URI
    Then I should receive an 'invalid URI' notification
    And the service component URI should remain unchanged

  Scenario: Invalid service component
    Given an invalid service component
    When I request configuration of the service component
    Then I should receive an 'invalid service component' notification

  Scenario: Failure
    Given a valid URI
    And an existing service component
    And a failure
    When I request configuration of the service component with the URI
    Then I should receive a 'failure configuring service component' notification
    And the service component URI should remain unchanged
