Feature: Teams are domain perspectives
  As a provisioner
  When provisioning teams
  Then I expect exactly the same behaviour as for domain perspectives
  And I want to label the domain perspectives as 'teams' in UDDI

  Scenario: New team
    Given a new team
    When I request registration of a 'teams' domain perspective
    Then I receive 'domain perspective registered' notification
    And the team should be available
