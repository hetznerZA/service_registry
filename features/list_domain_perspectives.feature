Feature: Listing domain perspectives
  As a provisioner
  When I am provisioning domain perspectives
  In order to select from a list of domain perspectives
  I want to retrieve a list of domain perspectives from the service registry

  Scenario: There is only one domain perspective
    Given one domain perspectives has been defined
    When I request a list of domain perspectives
    I want to receive a list containing the one domain perspective

  Scenario: There are more than one domain perspective
    Given multiple domain perspectives have been defined
    When I request a list of domain perspectives
    I want to receive a list containing the domain perspectives

  Scenario: There are no domain perspectives
    Given no domain perspectives have been defined
    When I request a list of domain perspectives
    I want to receive an empty list

  Scenario: An error occurs when listing domain perspectives
    Given domain perspectives have been defined
    And an error condition prevents listing domain perspectives
    When I request a list of domain perspectives
    I want to receive a 'request failure' notification

