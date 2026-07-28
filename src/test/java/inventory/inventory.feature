Feature: Inventory API

  Background:
    * url baseUrl

  @smoke
  Scenario: Verify that the inventory API is available
    Given path 'inventory'
    When method get
    Then status 200