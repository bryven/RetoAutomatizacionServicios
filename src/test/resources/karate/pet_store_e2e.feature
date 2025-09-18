Feature: PetStore E2E
  # Casos:
  # - @add_pet             → add pet
  # - @get_by_id           → add pet and find by id
  # - @update_pet          → add pet and update status
  # - @find_by_status      → add pet and find by status

  Background:
    * url urlBase
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json' }
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

    # payload base
    * def baseBody = read('classpath:jsonRequest/addPet.json')

    # Generadores Java
    * def Category = Java.type('transversal.GetName')
    * def category = new Category()
    * def Id = Java.type('transversal.SimpleIdGenerator')
    * def id = new Id()

    * def petCategory = category.returnCategory()
    * def petStatus = 'available'


  @add_pet
  Scenario: Add new pet
    * def body = JSON.parse(JSON.stringify(baseBody))
    * def petName = category.returnName()
    * def petId = id.generateId()
    * set body.id = petId
    * set body.category.name = petCategory
    * set body.name = petName
    * set body.tags[0].name = petName
    * set body.status = petStatus

    Given path '/pet'
    And request body
    When method post
    Then status 200
    And match response.id == petId
    And match response.name == petName
    And match response.status == petStatus


  @get_by_id
  Scenario: Find pet by ID
    * def body = JSON.parse(JSON.stringify(baseBody))
    * def petName = category.returnName()
    * def petId = id.generateId()
    * set body.id = petId
    * set body.category.name = petCategory
    * set body.name = petName
    * set body.tags[0].name = petName
    * set body.status = petStatus

    # crear
    Given path '/pet'
    And request body
    When method post
    Then status 200

    # consultar por ID
    Given path '/pet', petId
    When method get
    Then status 200
    And match response.id == petId
    And match response.name == petName


  @update_pet
  Scenario: Update pet
    * def body = JSON.parse(JSON.stringify(baseBody))
    * def petName = category.returnName()
    * def petId = id.generateId()
    * set body.id = petId
    * set body.category.name = petCategory
    * set body.name = petName
    * set body.tags[0].name = petName
    * set body.status = petStatus

    # crear
    Given path '/pet'
    And request body
    When method post
    Then status 200

    # cambiar estado a sold
    * def updatedName = petName + '-updated'
    * set body.name = updatedName
    * set body.status = 'sold'

    Given path '/pet'
    And request body
    When method put
    Then status 200
    And match response.id == petId

    # confirmación por GET con reintentos
    * configure retry = { count: 10, interval: 1000 }
    Given path '/pet', petId
    And retry until response && response.status == 'sold'
    When method get
    Then status 200
    And match response.status == 'sold'
    And match response.name == updatedName


  @find_by_status
  Scenario: Find by status
    * def body = JSON.parse(JSON.stringify(baseBody))
    * def petName = category.returnName()
    * def petId = id.generateId()
    * set body.id = petId
    * set body.category.name = petCategory
    * set body.name = petName
    * set body.tags[0].name = petName
    * set body.status = petStatus

    # crear
    Given path '/pet'
    And request body
    When method post
    Then status 200

    # cambiar estado a sold
    * def updatedName = petName + '-updated'
    * set body.name = updatedName
    * set body.status = 'sold'

    Given path '/pet'
    And request body
    When method put
    Then status 200

    # búsqueda con reintento
    * configure retry = { count: 20, interval: 1000 }
    Given path '/pet', 'findByStatus'
    And param status = 'sold'
    And retry until response && karate.filter(response, function(x){ return x.id == petId; }).length > 0
    When method get
    Then status 200
    And match response[*].id contains petId
