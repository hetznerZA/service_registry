Feature: Map service components to services
  As a service consumer
  When I have queried the service registry for a service
  And I receive a list of services
  In order to make use of the services
  I want to be given details about the service components

  Scenario: obtain a list of service components
    Given the result of a service query
    And service components providing the service
    When I index a service in the services list
    Then I obtain a list of service components that provide that service

  Scenario: no service components provide the service
    Given the result of a service query
    And no service components provide the service
    When I index a service in the services list
    Then I obtain an empty list of service components

  Scenario: mapping URIs to service components
    Given the result of a service query
    And the list of service components
    When I look at each service component entry
    Then I can extract a URI to the service on that service component

  Scenario: mapping status to service components
    Given the result of a service query
    And the list of service components
    When I look at each service component entry
    Then I can extract a status of the service component providing that service
