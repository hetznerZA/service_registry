Feature: Registering service definitions
  As a provisioner
  When registering a service
  In order to have the services available and understood
  I want to register a service definition for the service

  Scenario: service definition valid
    Given unknown service identifier
    And valid service definition
    When I register the service definition with the service
    Then I receive 'unknown service identifier' notification
    And the service unavailable

  Scenario: service already registered
    Given an existing service identifier
    And a service definition
    When I register the service definition with the service
    Then I receive 'success' notification
    And the service is described by the service definition

  Scenario: service identifier invalid
    Given invalid service identifier
    When I register a service definition with the service
    Then I receive 'invalid service identifier' notification

  Scenario: service definition invalid
    Given a service identifier
    And invalid service definition
    When I register the service definition with the service
    Then I receive 'invalid service definition' notification


