Feature: Youtube ads displaying

Scenario: As user with AdBlock On I want to know if I can see any Ads
  Given I am on youtube.com with adblock on
  When I choose video from a input list and see results

  @disable_adblock
Scenario: As user with AdBlock Off I want to know if I can see any Ads
    Given I am on youtube.com with adblock off
    Then I choose video from a input list and see results
