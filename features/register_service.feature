Feature: Registering service definitions
  As a provisioner
  When registering a service
  In order to have the services available and understood
  I want to register a service definition for the service

  Scenario: service already registered
    Given a service identifier
    And a service definition
    And the service is already registered
    When I register the service definition with the service
    Then I receive a 'duplicate service definition' notification

  Scenario: service identifier invalid
    Given an invalid service identifier
    When I register a service definition with the service
    Then I receive an 'invalid service' notification

  Scenario: service definition invalid
    Given a service identifier
    And an invalid service definition
    When I register the service definition with the service
    Then I receive an 'invalid service definition' notification

  Scenario: service definition valid
    Given a service identifier
    And a valid service definition
    When I register the service definition with the service
    Then I receive a 'success' notification
    And the service is described by the service definition
