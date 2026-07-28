Feature: Inventory API

  Background:
    * url baseUrl
    * def inventoryItems = read('classpath:inventory/data/inventory-items.json')

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

  Scenario: Filter inventory item by id
    * def expectedItem = inventoryItems.bakedRolls

    Given path 'inventory', 'filter'
    And param id = expectedItem.id
    When method get
    Then status 200
    And match response == expectedItem