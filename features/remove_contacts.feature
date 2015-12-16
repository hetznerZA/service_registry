Feature: Removing a contact for a domain perspectives
  As a staff member
  When I need to know who owns, is responsible and accountable for a team's entities
  In order for a stale contact to no longer be associated with a domain perspective
  I want to remove the contact to the domain perspective

  Scenario: No domain perspective
    Given no domain perspective
    When I remove the contact from the domain perspective
    Then I receive 'no domain perspective provided' notification

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    When I remove the contact from the domain perspective
    Then I receive 'invalid domain perspective provided' notification

  Scenario: No contact details
    Given an existing domain perspective
    And no contact details
    When I remove the contact from the domain perspective
    Then I receive 'no contact details provided' notification

  Scenario: Invalid contact details
    Given an existing domain perspective
    And invalid contact details
    When I remove the contact from the domain perspective
    Then I receive 'invalid contact details provided' notification

  Scenario: Existing contact
    Given an existing domain perspective
    And existing contact name
    When I remove the contact from the domain perspective
    Then the contact is no longer associated with the domain perspective

  Scenario: Non-existing contact
    Given an existing domain perspective
    And valid contact details
    When I remove the contact from the domain perspective
    Then I receive 'unknown contact' notification

  Scenario: failure
    Given a domain perspective
    And a failure
    When I remove the contact from the domain perspective
    Then I receive 'failure removing contact' notification