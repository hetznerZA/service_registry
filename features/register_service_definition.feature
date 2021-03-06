Feature: Registering service definitions
  As a provisioner
  When provisioning services
  In order to have the services available and understood
  I want to register a service definition for the service

  Scenario: Not authorized
    Given unauthorized publisher
    And a registered service
    And valid service definition
    When I register the service definition with the service
    Then I receive 'not authorized' notification

  Scenario: service definition valid
    Given unknown service identifier
    And valid service definition
    When I register the service definition with the service
    Then I receive 'unknown service provided' notification

  Scenario: service already registered
    Given a registered service
    And valid service definition
    When I register the service definition with the service
    Then I receive 'service definition registered' notification
    And the service is described by the service definition

  Scenario: no service identifier
    Given no service
    When I register the service definition with the service
    Then I receive 'no service provided' notification

  Scenario: service identifier invalid
    Given invalid service identifier
    When I register the service definition with the service
    Then I receive 'invalid service provided' notification

  Scenario: no service definition
    Given valid service
    And no service definition
    When I register the service definition with the service
    Then I receive 'no service definition provided' notification
    And the service definition associated with the service remains unchanged

  Scenario: service definition invalid
    Given valid service
    And invalid service definition
    When I register the service definition with the service
    Then I receive 'invalid service definition provided' notification
    And the service definition associated with the service remains unchanged

  Scenario: failure
    Given valid service
    And valid service definition
    And a failure
    When I register the service definition with the service
    Then I receive 'failure registering service definition' notification
    And the service definition associated with the service remains unchanged
