Feature: Configuring meta for a service component
  As a provisioner
  When configuring a service component
  In order to enable management of service components
  I want to configure meta for the service component

  Scenario: Not authorized
    Given existing service component identifier
    And valid meta
    And unauthorized publisher
    When I request configuration of the service component with meta
    Then I receive 'not authorized' notification

  Scenario: Providing meta for a service component
    Given valid meta
    And existing service component identifier
    When I request configuration of the service component with meta
    Then the service component should know about the meta

  Scenario: Invalid meta
    Given existing service component identifier
    And the service component has meta configured
    And invalid meta
    When I request configuration of the service component with meta
    Then I receive 'invalid meta provided' notification
    And the service component meta should remain unchanged

  Scenario: No meta
    Given existing service component identifier
    And the service component has meta configured
    And no meta
    When I request configuration of the service component with meta
    Then I receive 'no meta provided' notification
    And the service component meta should remain unchanged

  Scenario: No service component
    Given valid meta
    And no service component identifier
    When I request configuration of the service component with meta
    Then I receive 'no service component provided' notification

  Scenario: Invalid service component
    Given valid meta
    And invalid service component identifier
    When I request configuration of the service component with meta
    Then I receive 'invalid service component provided' notification

  Scenario: Unknown service component
    Given valid meta
    And unknown service component identifier
    When I request configuration of the service component with meta
    Then I receive 'unknown service component provided' notification

  Scenario: Failure
    Given valid meta
    And existing service component identifier
    And the service component has meta configured
    And a failure
    When I request configuration of the service component with meta
    Then I receive 'failure configuring service component with meta' notification
    And the service component meta should remain unchanged