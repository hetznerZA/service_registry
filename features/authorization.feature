Feature: Authorizing publication
  As the service registry
  Given a publisher identity
  And content to publish
  When the publisher requests publication of the content
  In order to avoid malicious publication
  I want authorize the publisher

  Scenario: No identity
    Given no publisher identity
    When publishing content
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when associating service components and domains
    Given an unauthorized publisher identity
    When I request association with the domain perspective
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when associating service components and services
    Given an unauthorized publisher identity
    When I request association with the service
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when configuring meta for a service
    Given an unauthorized publisher identity
    When I request configuration of the service with meta
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when deregistering a domain perspective
    Given an unauthorized publisher identity
    When I request deregistration of the domain perspective
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when deregistering a service
    Given an unauthorized publisher identity
    When I request deregistration of the service
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when deregistering a service component
    Given an unauthorized publisher identity
    When I request deregistration of the service component
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when deregistering a service definition
    Given an unauthorized publisher identity
    When I deregister the service definition
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when registering a domain perspective
    Given an unauthorized publisher identity
    When I request registration of the domain perspective
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when registering a service
    Given an unauthorized publisher identity
    When I request registration of the service
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when registering a service component
    Given an unauthorized publisher identity
    When I request registration of the service component
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when registering a service definition
    Given an unauthorized publisher identity
    When I register the service definition with the service
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when removing a service component from a domain perspective
    Given an unauthorized publisher identity
    When I remove the service component association
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when removing a service component service association
    Given an unauthorized publisher identity
    When I remove the service association
    Then I receive 'not authorized' notification

  Scenario: Identity not authorized when configuring a URI for a service component
    Given an unauthorized publisher identity
    When I request configuration of the service component
    Then I receive 'not authorized' notification

