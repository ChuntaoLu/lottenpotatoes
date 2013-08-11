Feature: movies when added should appear in movie list

Scenario: view movie list after adding movie (declarative and DRY)

  Given I have added "Apocalypse Now" with rating "R"
  And   I have added "Zorro" with rating "PG-13"
  And   I am on the RottenPotatoes home page
  Then  I should see "Apocalypse Now" before "Zorro" 
