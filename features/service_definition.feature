Feature: Retrieve a service definition for a service
  Given a service
  When I need to know how the service is defined
  In order to interpret the service definition
  I want to retrieve the service definition

  Scenario: definition found
    Given a service identifier
    When I request the service definition
    Then I receive the service definition

  Scenario: definition not found
    Given a service identifier
    And the service identifier is unknown
    When I request the service definition
    Then I receive a 'not found' notification
