Feature: Listing endpoints for a service
  As a service consumer
  In order to access a service
  I want a list of the service's URIs

  Scenario: Not authorized
    Given a registered service
    And unauthorized publisher
    When I request a list of service URIs
    Then I receive 'not authorized' notification

  Scenario: Valid service with URIs
    Given a registered service
    And the service has URIs configured
    When I request a list of service URIs
    Then I receive the list of URIs

  Scenario: No service
    Given no service
    When I request a list of service URIs
    Then I receive 'no service provided' notification

  Scenario: Invalid service
    Given invalid service identifier
    When I request a list of service URIs
    Then I receive 'invalid service identifier provided' notification

  Scenario: Failure
    Given a registered service
    And a failure
    When I request a list of service URIs
    Then I receive 'failure listing service URIs' notification
