Feature: User can delete a movie
@javascript
Scenario: Delete a movie
  Given I have added "Amelie" with rating "G" 
  And   I have added "Alpha" with rating "G" 
  And   I am on the details page for "Amelie"
  When  I press "Delete" 
  And   I confirm popup
  Then  I am on the RottenPotatoes home page
  And   I should not see "Amelie"
