Feature: Listing service associations
  As a provisioner
  When I want to do maintenance on a service
  In order to know which service components and domain perspectives will be affected
  I want to obtain a list of associations for the service

  Scenario: No associations
    Given a registered service
    And no service associations
    When I request associations for the service
    Then I receive an empty association dictionary

  Scenario: Domain perspective associations
    Given a registered service
    And an existing domain perspective
    And the service is already associated with the domain perspective
    When I request associations for the service
    Then I receive an association dictionary with the domain perspective associations

  Scenario: Service component associations
    Given a registered service
    And valid URI
    And the service has URIs configured
    When I request associations for the service
    Then I receive an association dictionary with the service component URIs

  Scenario: No service
    Given no service
    When I request associations for the service
    Then I receive 'no service provided' notification

  Scenario: Invalid service
    Given invalid service identifier
    When I request associations for the service
    Then I receive 'invalid service provided' notification

  Scenario: Unknown service
    Given unknown service identifier
    When I request associations for the service
    Then I receive 'unknown service provided' notification

  Scenario: failure
    Given a registered service
    And a failure
    When I request associations for the service
    Then I receive 'failure determining associations for service' notification
