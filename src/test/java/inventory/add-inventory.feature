Feature: Add inventory items

  Background:
    * url baseUrl
    * def inventoryItems = read('classpath:inventory/data/inventory-items.json')
    * def hawaiian = inventoryItems.hawaiian

  Scenario: Add item for non-existent id
    Given path 'inventory', 'add'
    And request hawaiian
    When method post
    Then status 200
    And match response == 'OK'

  Scenario: Add item for existent id
    Given path 'inventory', 'add'
    And request hawaiian
    When method post
    Then status 400
    And match response == 'Bad Request'

  Scenario: Try to add item with missing information
    * def incompleteHawaiian = karate.toJson(hawaiian)
    * remove incompleteHawaiian.id

    Given path 'inventory', 'add'
    And request incompleteHawaiian
    When method post
    Then status 400
    And match response == 'Not all requirements are met'

  Scenario: Validate recently added item is present in the inventory
    Given path 'inventory'
    When method get
    Then status 200
    And match response.data contains hawaiian