Feature: De-registering a service
  As a provisioner
  Given a service
  When the service is no longer relevant
  In order to have the service no longer available
  I want to deregister the service

  Scenario: Not authorized
    Given unauthorized publisher
    When I request deregistration of the service
    Then I receive 'not authorized' notification

  Scenario: No service
    Given no service
    When I request deregistration of the service
    Then I receive 'no service identifier provided' notification

  Scenario: Invalid service
    Given invalid service identifier
    When I request deregistration of the service
    Then I receive 'invalid service identifier provided' notification

  Scenario: Unknown service
    Given unknown service identifier
    When I request deregistration of the service
    Then I receive 'service unknown' notification

  Scenario: Existing service
    Given a registered service
    When I request deregistration of the service
    Then I receive 'service deregistered' notification
    And the service should not be available

  Scenario: failure
    Given a registered service
    And a failure
    When I request deregistration of the service
    Then I receive 'failure deregistering service' notification
    And the service should be available
