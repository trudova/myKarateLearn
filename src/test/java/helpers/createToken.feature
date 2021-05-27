Feature: create token

  Scenario: get token
    Given url apiUrl
    Given path "/users/login"
    And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
    When method Post
    Then status 200
    * def authToken = response.user.token