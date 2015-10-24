Feature: Deregistering a service definition
  As a provisioner
  When maintaining a service
  In order to have services no longer available
  I want to deregister service definitions

  Scenario: invalid service identifier
    Given invalid service identifier
    When I deregister the service definition
    Then I receive 'invalid service' notification

  Scenario: valid service identifier
    Given valid service identifier
    When I deregister the service definition
    Then I receive 'success' notification
    And the service is no longer described by the service definition
