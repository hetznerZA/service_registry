Feature: Configuring meta for a service
  As a provisioner
  When configuring a service
  In order to have the service behave dynamically
  I want to configure meta for the service

  Scenario: Not authorized
    Given a registered service
    And valid meta
    And unauthorized publisher
    When I request configuration of the service with meta
    Then I receive 'not authorized' notification

  Scenario: Providing meta for a service component
    Given valid meta
    And a registered service
    When I request configuration of the service with meta
    Then the service should know about the meta

  Scenario: Invalid meta
    Given a registered service
    And the service has meta configured
    And invalid meta
    When I request configuration of the service with meta
    Then I receive 'invalid meta provided' notification
    And the service meta should remain unchanged

  Scenario: No meta
    Given a registered service
    And the service has meta configured
    And no meta
    When I request configuration of the service with meta
    Then I receive 'no meta provided' notification
    And the service meta should remain unchanged

  Scenario: No service
    Given valid meta
    And no service
    When I request configuration of the service with meta
    Then I receive 'no service identifier provided' notification

  Scenario: Invalid service
    Given valid meta
    And invalid service identifier
    When I request configuration of the service with meta
    Then I receive 'invalid service identifier provided' notification

  Scenario: Failure
    Given valid meta
    And a registered service
    And the service has meta configured
    And a failure
    When I request configuration of the service with meta
    Then I receive 'failure configuring service with meta' notification
    And the service meta should remain unchanged
