Feature: Obtaining service definitions from service components
  As a provisioner
  Given a service component
  When maintaining a service component
  In order to see which services are available
  I want to retrieve the list of service definitions

  Scenario: invalid service component
    Given invalid service component identifier
    When I request service definitions
    Then I receive 'invalid service component' notification

  Scenario: no services associated
    Given valid service component
    And no services associated with the service component
    When I request service definitions
    Then I receive no services
    And no service definitions

  Scenario: services associated
    Given valid service component
    And services associated with the service component
    When I request service definitions
    Then I should a list of services
    And service definitions for all services
