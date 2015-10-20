Feature: De-registering a service
  As a provisioner
  Given a service component
  When the service component is no longer relevant
  In order to have the service component no longer available
  I want to deregister the service component

  Scenario: No service component
    Given no service component identifier
    When I request deregistration of the service component
    Then I should receive a 'no service component identifier provided' notification

  Scenario: Invalid service component
    Given invalid service component identifier
    When I request deregistration of the service component
    Then I should receive a 'invalid service component identifier' notification

  Scenario: Unknown service component
    Given an unknown service component
    When I request deregistration of the service component
    Then I should receive a 'service component unknown' notification

  Scenario: Existing service component
    Given an existing service component identifier
    And no services associated with the service component
    When I request deregistration of the service component
    Then I should receive a 'service component deregistered' notification
    And the service component should not be available

  Scenario: Associated services
    Given an existing service component identifier
    And services associated with the service component
    When I request deregistration of the service component
    Then I should receive a 'service component has service associations' notification
    And the service component should be available

  Scenario: Associated domain perspectives
    Given an existing service component identifier
    And domain perspectives associated with the service component
    When I request deregistration of the service component
    Then I should receive a 'service component has domain perspective associations' notification
    And the service component should be available

  Scenario: failure
    Given an existing service component identifier
    And no services associated with the service component
    And a failure
    When I request deregistration of the service component
    Then I should receive an error indicating 'failure deregistering service component' 
    And the service component should be available
