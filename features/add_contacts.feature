Feature: Add a contact for a domain perspectives
  As a staff member
  When I need to know who owns, is responsible and accountable for a team's entities
  In order for a contact to be associated with a domain perspective
  I want to add the contact to the domain perspective

  Scenario: No domain perspective
    Given no domain perspective
    When I add the contact to the domain perspective
    Then I receive 'no domain perspective provided' notification

  Scenario: Invalid domain perspective
    Given invalid domain perspective
    When I add the contact to the domain perspective
    Then I receive 'invalid domain perspective provided' notification

  Scenario: Unknown domain perspective
    Given an unknown domain perspective
    When I add the contact to the domain perspective
    Then I receive 'unknown domain perspective provided' notification

  Scenario: No contact details
    Given an existing domain perspective
    And no contact details
    When I add the contact to the domain perspective
    Then I receive 'no contact details provided' notification

  Scenario: Invalid contact details
    Given an existing domain perspective
    And invalid contact details
    When I add the contact to the domain perspective
    Then I receive 'invalid contact details provided' notification

  Scenario: Existing contact
    Given an existing domain perspective
    And existing contact name
    And valid contact details
    When I add the contact to the domain perspective
    Then I receive 'contact already exists - remove first to update' notification

  Scenario: New contact
    Given an existing domain perspective
    And valid contact details
    When I add the contact to the domain perspective
    Then the contact is associated with the domain perspective

  Scenario: failure
    Given an existing domain perspective
    And a failure
    When I add the contact to the domain perspective
    Then I receive 'failure adding contact' notification