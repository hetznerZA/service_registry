Feature: Registering service definitions
  As a provisioner
  When provisioning services
  In order to have the services available and understood
  I want to register a service definition for the service

  Scenario: service definition valid
    Given unknown service identifier
    And valid service definition
    When I register the service definition with the service
    Then I receive 'unknown service identifier provided' notification

  Scenario: service already registered
    Given a registered service
    And valid service definition
    When I register the service definition with the service
    Then I receive 'success' notification
    And the service is described by the service definition

  Scenario: no service identifier
    Given no service
    When I register the service definition with the service
    Then I receive 'no service identifier provided' notification

  Scenario: service identifier invalid
    Given invalid service identifier
    When I register the service definition with the service
    Then I receive 'invalid service identifier provided' notification

  Scenario: no service definition
    Given a registered service
    And no service definition
    When I register the service definition with the service
    Then I receive 'no service definition provided' notification
    And the service definition associated with the service remains unchanged

  Scenario: service definition invalid
    Given a registered service
    And invalid service definition
    When I register the service definition with the service
    Then I receive 'invalid service definition provided' notification
    And the service definition associated with the service remains unchanged

  Scenario: failure
    Given an existing service identifier
    And valid service definition
    And a failure
    When I register the service definition with the service
    Then I receive 'failure registering service definition' notification
    And the service definition associated with the service remains unchanged
