Feature: Deregistering a service definition
  As a provisioner
  When maintaining a service
  In order to have services no longer available
  I want to deregister service definitions

  Scenario: Not authorized
    Given unauthorized publisher
    When I deregister the service definition
    Then I receive 'not authorized' notification

  Scenario: invalid service identifier
    Given invalid service identifier
    When I deregister the service definition
    Then I receive 'invalid service identifier provided' notification

  Scenario: valid service identifier
    Given a registered service
    And a valid service definition
    And the service definition describes the service
    When I deregister the service definition
    Then I receive 'success' notification
    And the service is no longer described by the service definition
