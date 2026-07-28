Feature: Inventory API

  Background:
    * url baseUrl

  @smoke
  Scenario: Get all menu items
    Given path 'inventory'
    When method get
    Then status 200
    And match response contains { data: '#[]' }
    And assert response.data.length >= 9
    And match each response.data contains
      """
      {
        id: '#string',
        name: '#string',
        price: '#string',
        image: '#string'
      }
      """