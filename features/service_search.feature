Feature: Searching for a service
  As a service consumer
  When I have a need to be met
  In order to find a service that can meet the need
  I want to request a list of services that can meet the need

  Scenario: No services match
    Given a need
    And no services match
    When I request a list of services that can meet my need
    Then I receive an empty list of services

  Scenario: One match
    Given a need
    And one service match
    When I request a list of services that can meet my need
    Then I receive a list of services with one entry
    And the entry should match my need

  Scenario: Multiple matches
    Given a need
    And multiple service matches
    When I request a list of services that can meet my need
    Then I receive a list of services with multiple entries
    And the entries should all match my need

  Scenario: Match by service ID
    Given a service ID
    When I request the service by ID
    Then I receive a list with the service as the single entry in it

  Scenario: No match for the service ID
    Given a service ID
    And no match for the service ID
    When I request the service by ID
    Then I receive an empty list of services

  Scenario: Match by pattern in ID
    Given a pattern
    And a service with the pattern in the ID
    When I request services matching the pattern
    Then I receive a list with the service included

  Scenario: Match by pattern in description
    Given a pattern
    And a service with the pattern in the description
    When I request services matching the pattern
    Then I receive a list with the service included

  Scenario: No pattern
    Given no pattern
    When I request services matching the pattern
    Then I receive 'no pattern provided' notification
    
  Scenario: Invalid pattern
    Given invalid pattern
    When I request services matching the pattern
    Then I receive 'invalid pattern provided' notification

#  Scenario: Match by pattern in service definition
#    Given a pattern
#    And a service with the pattern in the service definition
#    When I request services matching the pattern
#    Then I receive a list with the service included

  Scenario: Filter by domain perspective
    Given a pattern
    And multiple existing services
    And multiple existing service components
    And multiple existing domain perspectives
    And the services are associated with different domain perspectives
    When I request services matching the pattern in the domain perspective
    Then I receive a list of services matching the pattern
    And all services in the list must be in the domain perspective
