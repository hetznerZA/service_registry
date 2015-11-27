Feature: Registering service components
  As a provisioner
  When I have a service component
  In order to make the service component available in the domain perspective
  I want to register the service component

  Scenario: Not authorized
    Given a new service component identifier
    And unauthorized publisher
    When I request registration of the service component
    Then I receive 'not authorized' notification

  Scenario: No identifier
    Given no service component identifier
    When I request registration of the service component
    Then I receive 'no service component provided' notification
    And the service component should not be available

  Scenario: New service component
    Given a new service component identifier
    When I request registration of the service component
    Then I receive 'service component registered' notification
    And the service component should be available

  Scenario: Existing service component
    Given existing service component identifier
    When I request registration of the service component
    Then I receive 'service component already exists' notification
    And the service component should still be available, unchanged

  Scenario: Invalid service component identifier
    Given invalid service component identifier
    When I request registration of the service component
    Then I receive 'invalid service component provided' notification
    And the service component should not be available

  Scenario: failure
    Given a new service component identifier
    And a failure
    When I request registration of the service component
    Then I receive 'failure registering service component' notification
    And the service component should not be available
