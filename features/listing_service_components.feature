Feature: Listing service components
  As a people or service entity
  When I am interested in service components
  And I have a domain perspective of interest
  In order to know which service components exist
  I want to retrieve a list of service components

  Scenario: One or more service components and no domain perspective
    Given no domain perspective
    When service components are listed
    Then I should receive list of all service components

  Scenario: No service components and no domain perspective
    Given a domain perspective
    And no service components exist
    When service components are listed
    Then I should receive an empty list

  Scenario: No service components
    Given a domain perspective
    And no service components exit
    When service components are listed
    Then I should receive an empty list

  Scenario: One or more service components
    Given a domain perspective
    And one or more service components exit
    When service components are listed
    Then I should receive a list with all the service components

  Scenario: failure
    Given a domain perspective
    And any failure
    When service components are listed
    Then I should receive an error indicating 'failure retrieving service components' 
