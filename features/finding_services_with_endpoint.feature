Feature: finding services and their URIs for services that has the specified pattern in their URIs
  As a provisioner
  When I want to do maintenance on a service component
  In order to know which services will be affected
  I want to obtain a list of services whose URI include the service component

  Scenario: One service, one match
    Given valid URI pattern
    And a registered service
    And the service has a matching URI configured
    When I search for the pattern in service URIs
    Then I receive the service and the matching URI

  Scenario: Multiple services, matches
    Given valid URI pattern
    And multiple existing services
    And the services have matching URIs configured
    When I search for the pattern in service URIs
    Then I receive the services and the matching URIs

  Scenario: One service, multiple matches
    Given valid URI pattern
    And a registered service
    And the service has multiple matching URIs configured
    When I search for the pattern in service URIs
    Then I receive the service and the matching URIs

  Scenario: No pattern
    Given no pattern
    When I search for the pattern in service URIs
    Then I receive 'no pattern provided' notification
    
  Scenario: Invalid pattern
    Given invalid URI pattern
    When I search for the pattern in service URIs
    Then I receive 'invalid pattern provided' notification

  Scenario: No services match
    Given valid URI pattern
    And no services match the pattern
    When I search for the pattern in service URIs
    Then I receive an empty list of services
