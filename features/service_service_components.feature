Feature: Map service components to services
  As a service consumer
  When I have queried the service registry for a service
  And I receive a list of services
  In order to make use of the services
  I want to be given details about the service components

  Scenario: obtain a list of service components
    Given a need
    And existing service component identifier
    And a registered service
    And one service match
    And the service is associated with the service component
    When I request a list of services that can meet my need
    Then I obtain a list of service components that provide that service

  Scenario: no service components provide the service
    Given a need
    And one service match
    And the service is not associated with any service components
    When I request a list of services that can meet my need
    Then I receive an empty list of services components

  Scenario: mapping URIs to service components
    Given a need
    And valid URI
    And one service match
    And existing service component identifier
    And I request configuration of the service component
    And the service is associated with the service component
    When I request a list of services that can meet my need
    Then I can extract a URI to the service on a service component

  Scenario: mapping status to service components
    Given a pending test
    #Given a need
    #And existing service component identifier
    #And one service match
    #And the service is associated with the service component
    #When I request a list of services that can meet my need
    #Then I can extract a status of the service component providing that service

  Scenario: multiple service components providing the service
    Given a need
    And multiple existing service components
    And one service match
    And the service is associated with two service components
    When I request a list of services that can meet my need
    Then I can extract all service components providing the service
