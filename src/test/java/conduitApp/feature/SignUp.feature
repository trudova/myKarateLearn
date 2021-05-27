#@ignore
Feature: sign up new User

  Background: preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def timeValidator = read('classpath:helpers/timeValidater.js')
    Given url apiUrl


  Scenario: sign up with a new user
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUserName()

    #below ia user name with js function
    * def jsFunction =
    """
    function() {
  var DataGenerator = Java.type('helpers.DataGenerator')
  var generator = new DataGenerator();
  return generator.getRandomUserName2()
    }
    """
    * def randomUserName2 = call jsFunction

    Given path "/users"
    And request
  """
  {"user": {"email": #(randomEmail), "password": "karate123", "username": #(randomUsername)}}
  """
    When method Post
    Then status 200
    And match response ==
    """
    {
    "user": {
        "id": '#number',
        "email": "#(randomEmail)",
        "createdAt": "#? timeValidator(_)",
        "updatedAt": "#? timeValidator(_)",
        "username": "#(randomUsername)",
        "bio": null,
        "image": null,
        "token": "#string"
    }
}
    """


  Scenario Outline: Validate Sign Up error messages
    Given path '/users'
    And request
        """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<username>"
                }
            }
        """
    When method Post
    Then status 422
    And print response
    And match response == <errorResponse>

    Examples:
      | email                | password  | username          | errorResponse                                                                            |
      | #(randomEmail)       | Karate123 | KarateUser123     | {"errors": {"email": ["is invalid"],"username": ["has already been taken"]}}             |
      | KarateUser1@test.com | Karate123 | #(randomUsername) | {"errors": {"email": ["has already been taken"],"username": ["has already been taken"]}} |
