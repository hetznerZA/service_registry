Feature: Registering service components
  As a developer
  When I have instantiated a new service component
  In order to make the service component available
  I want to register the service component

  Scenario: No domain perspective
    Given no domain perspective
    When I request registration of the service component
    Then I should receive a 'no domain perspective provided' notification
    And the service component should not be available

  Scenario: No service definitions
    Given no service definitions
    When I request registration of the service component
    Then I should receive a 'no service definitions provided' notification
    And the service component should not be available

  Scenario: No identifier
    Given no identifier
    When I request registration of the service component
    Then I should receive a 'no identifier provided' notification
    And the service component should not be available

  Scenario: No URI
    Given no URI
    When I request registration of the service component
    Then I should receive a 'no URI provided' notification
    And the service component should not be available

  Scenario: New service component
    Given a new service component identifier
    And a domain perspective
    And a services definition
    And a URI
    When I request registration of the service component
    Then I should receive a 'success' notification
    And the service component spective should be available

  Scenario: Existing service component
    Given an existing service component identifier
    When I request registration of the service component
    Then I should receive a 'service component already exists' notification
    And the service component should still be available, unchanged

  Scenario: Invalid service component identifier
    Given invalid service component identifier
    When I request registration of the service component
    Then I should receive a 'invalid identifier' notification
    And the service component should not be available

  Scenario: Invalid services definition
    Given a new service component identifier
    And an invalid services definition
    When I request registration of the service component
    Then I should receive a 'invalid services definition' notification
    And the service component should not be available

  Scenario: Invalid domain perspective
    Given a new service component identifier
    And an invalid domain perspective
    When I request registration of the service component
    Then I should receive a 'invalid domain perspective' notification
    And the service component should not be available

  Scenario: Invalid URI
    Given a new service component identifier
    And an invalid URI
    When I request registration of the service component
    Then I should receive a 'invalid URI' notification
    And the service component should not be available

  Scenario: failure
    Given a new service component identifier
    And any failure
    When I request registration of the service component
    Then I should receive an error indicating 'failure registering service component' 
    And the service component should not be available
