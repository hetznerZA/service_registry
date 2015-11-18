Feature: Listing service components
  As a provisioner
  When I am provisioning service components
  In order to present service components for provisioning
  I want to retrieve a list of service components

  Scenario: One or more service components and no domain perspective
    Given no domain perspective
    And one or more service components exist
    When service components are listed
    Then I receive a list with all the service components

  Scenario: No service components and no domain perspective
    Given no domain perspective
    And no service components exist
    When service components are listed
    Then I receive an empty list of service components

  Scenario: No service components and a domain perspective
    Given a domain perspective
    And no service components exist in the domain perspective
    When service components are listed
    Then I receive an empty list of service components

  Scenario: One or more service components and a domain perspective
    Given an existing domain perspective
    And one or more service components exist in the domain perspective
    When service components are listed
    Then I receive a list with all the service components in the domain perspective

  Scenario: failure
    Given a domain perspective
    And a failure
    When service components are listed
    Then I receive 'failure retrieving service components' notification
