Given /I have added "(.*)" with rating "(.*)"/ do |title, rating|
  steps %Q{
    Given I am on the Create New Movie page
    When  I fill in "Title" with "#{title}"
    And   I select "#{rating}" from "Rating"
    And   I press "Save Changes"
  }
end

Then /I should see "(.*)" before "(.*)" on (.*)/ do |string1, string2, path|
  step "I am on #{path}"
  regexp = /#{string1}.*#{string2}/m #  /m means match across newlines
  page.body.should =~ regexp
end

# currently not working, need to figure out confirm popup
Given /I have deleted the movie: "(.*)"/ do |title|
  steps %Q{
    Given I am on the RottenPotatoes home page
    And   I follow "More about #{title}"
    And   I press "Delete"
    And   I confirm popup
  }
end
