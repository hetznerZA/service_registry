Feature: Bootstrap with identifier
  As a service registry
  When I have proceeded past bootstrap
  In order to identify myself with other systems
  I want to have an identifier

  Scenario: No identifier provided
    Given no identifier bootstrap
    When I am initializing
    Then I need to present a 'no identifier' notification
    And I should not be available

  Scenario: Invalid identifier
    Given invalid identifier bootstrap
    When I am initializing
    Then I need to present 'invalid identifier' notification
    And I should not be available

  Scenario: Valid identifier
    Given valid identifier bootstrap
    When I am initializing
    Then I need to present a 'valid identifier' notification
    And I should be available
