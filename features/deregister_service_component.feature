Feature: De-registering a service
  As a provisioner
  Given a service component
  When the service component is no longer relevant
  In order to have the service component no longer available
  I want to deregister the service component

  Scenario: No service component
    Given no service component identifier
    When I request deregistration of the service component
    Then I receive 'no service component identifier provided' notification

  Scenario: Invalid service component
    Given invalid service component identifier
    When I request deregistration of the service component
    Then I receive 'invalid service component identifier' notification

  Scenario: Unknown service component
    Given an unknown service component
    When I request deregistration of the service component
    Then I receive 'service component unknown' notification

  Scenario: Existing service component
    Given an existing service component identifier
    And no services associated with the service component
    When I request deregistration of the service component
    Then I receive 'service component deregistered' notification
    And the service component should not be available

  Scenario: Associated services
    Given an existing service component identifier
    And services associated with the service component
    When I request deregistration of the service component
    Then I receive 'service component has service associations' notification
    And the service component should be available

  Scenario: Associated domain perspectives
    Given an existing service component identifier
    And an existing domain perspective
    And domain perspectives associated with the service component
    When I request deregistration of the service component
    Then I receive 'service component has domain perspective associations' notification
    And the service component should be available

  Scenario: failure
    Given an existing service component identifier
    And no services associated with the service component
    And a failure
    When I request deregistration of the service component
    Then I receive 'failure deregistering service component' notification
    And the service component should be available
