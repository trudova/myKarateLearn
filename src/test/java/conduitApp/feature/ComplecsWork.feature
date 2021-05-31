Feature: Home Work

  Background: Preconditions
    * url apiUrl

  Scenario: Favorite articles
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().get("title")
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().get("description")
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().get("body")

  Scenario: Create a new article
    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 200
        # Step 1: Get atricles of the global feed
    * def timeValidator = read('classpath:helpers/timeValidater.js')
    Given params {limit: 10, offset: 0 }
    Given path "articles"
    When method Get
    Then status 200
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
    And def favoritesCount = response.articles[0].favoritesCount
    And print favoritesCount

    And  def slugVal = response.articles[0].slug
    And print slugVal
        # Step 3: Make POST request to increse favorites count for the first article
    * def article = response.articles[0]
    And karate.call('classpath:helpers/AddLikes.feature', article)
#        # Step 4: Verify response schema
    And match response.article ==
    """
{
        "title": "#string",
        "slug": "#string",
        "body": "#string",
        "createdAt": "#? timeValidator(_)",
        "updatedAt": "#? timeValidator(_)",
        "tagList": [],
        "description": "#string",
        "author": "#object",
        "favorited": "#boolean",
        "favoritesCount": "#number"
    }
    """

    And def newFave = response.article.favoritesCount


        # Step 5: Verify that favorites article incremented by 1
            #Example
    And match newFave == favoritesCount + 1

 # Step 6: Get all favorite articles
        # Step 7: Verify response schema

    Given params {limit: 10, offset: 0 }
    Given path "articles"
    When method Get
    Then status 200
    And match each response.articles ==
    """
      {
            "title": "#string",
            "slug": "#string",
            "body": "#string",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "tagList": "#array",
            "description": "#string",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            },
            "favorited": "#boolean",
            "favoritesCount": "#number"
        }
    """
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
  And match response..slug contains slugVal

  Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        # Step 2: Get the slug ID for the first arice, save it to variable
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        # Step 4: Verify response schema
        # Step 5: Get the count of the comments array lentgh and save to variable
            #Example
    * def responseWithComments = [{"article": "first"}, {article: "second"}]
    * def articlesCount = responseWithComments.length
        # Step 6: Make a POST request to publish a new comment
        # Step 7: Verify response schema that should contain posted comment text
        # Step 8: Get the list of all comments for this article one more time
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        # Step 10: Make a DELETE request to delete comment
        # Step 11: Get all comments again and verify number of comments decreased by 1