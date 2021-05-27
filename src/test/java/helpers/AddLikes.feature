Feature: add likes

  Background: go to url
    Given url apiUrl

  Scenario: add likes
    Given path 'articles',slug,'favorite'
    And request {}
    When method Post
    Then status 200
    * def likesCount = response.article.favoritesCount