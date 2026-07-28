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