Feature: Hooks

  Background: hooks
    * def result = callonce read('classpath:helpers/Dummy.feature')
    * def username = result.username
     # after hooks
    * configure afterScenario = function(){ karate.call('classpath:helpers/Dummy.feature')}
    * configure afterFeature =
    """
    function(){
    karate.log("After feature something")
    }
    """

  Scenario: first scenario
     * print username
    * print "This is first scenario"


  Scenario: second scenario
    * print "This is first second"
    * print username
