Feature: De-registering a service component
  As a provisioner
  Given a service component
  And a domain perspective
  When a service component should no longer be associated with the domain perspective
  In order to have the association no longer available
  I want to deregister the service component from the domain perspective

  Scenario: service component not registered in domain perspective
    Given a service component
    And a domain perspective
    And the service component is not registered in the domain perspective
    When I request deregistration of the service component from the domain perspective
    Then I should receive a 'not registered' notification

  Scenario: invalid service component
    Given an invalid service component
    And a domain perspective
    When I request deregistration of the service component from the domain perspective
    Then I should receive an 'invalid service component' notification

  Scenario: invalid domain perspective
    Given an invalid domain perspective
    And a service component
    When I request deregistration of the service component from the domain perspectiv
    Then I should receive an 'invalid domain perspective' notification

  Scenario: service component registered in domain perspective
    Given a service component
    And a domain perspective
    And the service component is registered in the domain perspective
    When I request deregistration of the service component from the domain perspective
    Then I should receive a success notification
    And the service component should no longer be registered in the domain perspective

