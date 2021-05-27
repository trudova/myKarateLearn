
Feature: log in functionality feature


  Background: Define URL
    * url apiUrl
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    And print dataGenerator.getRandomArticleValues().get("title")

    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().get("title")
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().get("description")
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().get("body")

#@ignore
  Scenario: Create a new article
    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 200
    And match response.article.title == articleRequestBody.article.title


  Scenario: create and delete article

    Given path '/articles'
    And request articleRequestBody
    When method Post
    Then status 200
    * def id = response.article.slug

    Given params {limit: 10, offset: 0}
    Given path "/articles"
    When method Get
    Then status 200
    And match response.articles[0].title == articleRequestBody.article.title

    Given path "/articles/", id
    When method Delete
    When status 200

    Given params {limit: 10, offset: 0}
    Given path "/articles"
    When method Get
    Then status 200
    And print response.articles[0].title
    And match response.articles[0].title != articleRequestBody.article.title

