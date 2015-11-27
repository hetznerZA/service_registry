Feature: De-registering a service component
  As a provisioner
  Given a service component
  When the service component is no longer relevant
  In order to have the service component no longer available
  I want to deregister the service component

  Scenario: Not authorized
    Given existing service component identifier
    And a domain perspective
    And no domain perspectives associated with the service component
    And unauthorized publisher
    When I request deregistration of the service component
    Then I receive 'not authorized' notification

  Scenario: No service component
    Given no service component identifier
    When I request deregistration of the service component
    Then I receive 'no service component identifier provided' notification

  Scenario: Invalid service component
    Given invalid service component identifier
    When I request deregistration of the service component
    Then I receive 'invalid service component provided' notification

  Scenario: Unknown service component
    Given an unknown service component
    When I request deregistration of the service component
    Then I receive 'service component unknown' notification

  Scenario: Existing service component
    Given existing service component identifier
    And no domain perspectives associated with the service component
    When I request deregistration of the service component
    Then I receive 'service component deregistered' notification
    And the service component should not be available

  Scenario: Associated domain perspectives
    Given existing service component identifier
    And an existing domain perspective
    And domain perspectives associated with the service component
    When I request deregistration of the service component
    Then I receive 'service component has domain perspective associations' notification
    And the service component should be available

  Scenario: failure
    Given existing service component identifier
    And a failure
    When I request deregistration of the service component
    Then I receive 'failure deregistering service component' notification
    And the service component should be available
