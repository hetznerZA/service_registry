Feature: Find contacts for domain perspectives
  As a staff member
  When I need to know who owns, is responsible and accountable for a team's entities
  In order to obtain contact details for that team
  I want to query the domain perspective for contact details

  Scenario: No domain perspective
    Given no domain perspective
    When I request contact details for the domain perspective
    Then I receive 'no domain perspective provided' notification

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    When I request contact details for the domain perspective
    Then I receive 'invalid domain perspective provided' notification

  Scenario: No contact details for the domain perspective
    Given an existing domain perspective
    And no contact details for the domain perspective
    When I request contact details for the domain perspective
    Then I receive an empty list of contacts

  Scenario: One contact for the domain perspective
    Given an existing domain perspective
    And one contact for the domain perspective
    When I request contact details for the domain perspective
    Then I receive a list with the contact

  Scenario: Multiple contacts for the domain perspective
    Given an existing domain perspective
    And multiple contacts for the domain perspective
    When I request contact details for the domain perspective
    Then I receive a list of all the contacts

  Scenario: failure
    Given a domain perspective
    And a failure
    When I request contact details for the domain perspective
    Then I receive 'failure retrieving contact details' notification