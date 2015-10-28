Feature: Deregistering a service definition
  As a provisioner
  When maintaining a service
  In order to have services no longer available
  I want to deregister service definitions

  Scenario: invalid service identifier
    Given invalid service identifier
    When I deregister the service definition
    Then I receive 'invalid service identifier provided' notification

  Scenario: valid service identifier
    Given a registered service
    And a valid service definition
    And it is described by a service definition
    When I deregister the service definition
    Then I receive 'success' notification
    And the service is no longer described by the service definition
