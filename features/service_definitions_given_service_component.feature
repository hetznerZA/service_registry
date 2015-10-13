Feature: Obtaining service definitions from service components
  As a provisioner
  Given a service component
  When maintaining a service component
  In order to see which services are available
  I want to retrieve the list of service definitions

  Scenario: invalid service component
    Given an invalid service component
    When I request service definitions
    Then I should receive an 'invalid service component' notification

  Scenario: no services associated
    Given a valid service component
    And no services associated with the service component
    When I request service definitions
    Then I should receive an empty list of services
    And no service definitions

  Scenario: services associated
    Given a valid service component
    And services associated with the service component
    When I request service definitions
    Then I should a list of services
    And service definitions for all services
