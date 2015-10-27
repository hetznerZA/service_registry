Feature: Bootstrap with configuration service
  As a service registry
  When I have proceeded past bootstrap
  In order to retrieve my configuration
  I want to have access to the configuration service

  Scenario: Invalid configuration service provided
    Given invalid configuration service bootstrap
    When I am initializing
    Then I need to present a 'invalid configuration service' notification
    And I should not be available

  Scenario: No configuration service provided
    Given no configuration service bootstrap
    When I am initializing
    Then I need to present a 'no configuration service' notification
    And I should not be available

  Scenario: Configuration service error
    Given a configuration service bootstrap
    And a problem accessing the configuration service
    When I am initializing
    Then I need to present a 'configuration error' notification
    And I should not be available

  Scenario: No configuration
    Given a configuration service bootstrap
    And no configuration stored in the configuration service
    When I am initializing
    Then I need to present 'invalid configuration' notification
    And I should not be available

  Scenario: Configuration valid
    Given a configuration service bootstrap
    And valid configuration in the configuration service
    When I am initializing
    Then I need to present a 'configuration valid' notification
    And I should be available
