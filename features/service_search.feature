Feature: Searching for a service
  As a service consumer
  When I have a need to be met
  In order to find a service that can meet the need
  I want to request a list of services that can meet the need

  Scenario: No services match
    Given a need
    And no services match
    When I request a list of services that can meet my need
    Then I should receive an empty list

  Scenario: One match
    Given a need
    And one service match
    When I request a list of services that can meet my need
    Then I should receive a list of services with one entry
    And the entry should match my need

  Scenario: Multiple matches
    Given a need
    And multiple service matches
    When I request a list of services that can meet my need
    Then I should receive a list of services with multiple entries
    And the entres should all match my need

  Scenario: Match by service name
    Given a service name
    When I request the service by name
    Then I should receive a list with the service as the single entry in it

  Scenario: No match for by service name
    Given a service name
    And no match for the service name
    When I request the service by name
    Then I should receive an empty list

  Scenario: Match by pattern in name
    Given a pattern
    And a service with the pattern in the name
    When I request services matching the pattern
    Then I should receive a list with the service included

  Scenario: Match by pattern in description
    Given a pattern
    And a service with the pattern in the description
    When I request services matching the pattern
    Then I should receive a list with the service included

  Scenario: Match by pattern in service definition
    Given a pattern
    And a service with the pattern in the service definition
    When I request services matching the pattern
    Then I should receive a list with the service included

  Scenario: Filter by domain perspective
    Given a pattern
    And a domain perspective
    When I request services matching the pattern in the domain perspective
    Then I should receive a list of services matching the pattern
    And all services in the list must be in the domain perspective
