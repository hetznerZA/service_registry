Feature: Registering services
  As a provisioner
  When I have a service
  In order to make the service available
  I want to register the service

  Scenario: Not authorized
    Given a new service identifier
    And unauthorized publisher
    When I request registration of the service
    Then I receive 'not authorized' notification

  Scenario: No identifier
    Given no service
    When I request registration of the service
    Then I receive 'no service identifier provided' notification
    And the service should not be available

  Scenario: New service
    Given a new service identifier
    When I request registration of the service
    Then I receive 'service registered' notification
    And the service should be available

  Scenario: Existing service
    Given a registered service
    When I request registration of the service
    Then I receive 'service already exists' notification
    And the service should still be available, unchanged

  Scenario: Invalid service identifier
    Given invalid service for registration
    When I request registration of the service
    Then I receive 'invalid service identifier provided' notification
    And the service should not be available

  Scenario: failure
    Given a new service identifier
    And a failure
    When I request registration of the service
    Then I receive 'failure registering service' notification
    And the service should not be available
