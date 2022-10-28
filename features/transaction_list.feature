Feature: display list of all transactions

  I am concerned about how much money I have spent
  So I want to see all the transactions

Background: transactions have been added to database

  Given the following transactions exist:
  | payer_email        | payee_email       | description           | currency       | amount | percentage |
  | aladdin@gmail.com  | bob@gmail.com     | Thai food for lunch   | US dollar      | 50     | 0.25       |
  | aladdin@gmail.com  | bob@gmail.com     | Concert               | US dollar      | 100,   | 0.5        |
  | aladdin@gmail.com  | carla@gmail.com   | Bar                   | US dollar      | 20     | 0.75       |
  | david@gmail.com    | aladdin@gmail.com | School supplies       | US dollar      | 20     | 1          |
  | emma@gmail.com     | aladdin@gmail.com | Rent                  | US dollar      | 2000   | 0.33       |
  | emma@gmail.com     | jack@gmail.com    | Rent                  | US dollar      | 2000   | 0.33       |
  | emma@gmail.com     | iris@gmail.com    | Rent                  | US dollar      | 2000   | 0.33       |

  And  I am on the Splitsy home page
  Then 7 seed transactions should exist

Scenario: restrict to movies with "PG" or "R" ratings
		#And I check the "PG" checkbox
		#Then complete the rest of of this scenario
  # enter step(s) to check the "PG" and "R" checkboxes
  When I check the following ratings: PG,R
  # When I check the "PG" checkbox
  # And I check the "R" checkbox
  # enter step(s) to uncheck all other checkboxes
  And I uncheck the following ratings: G,PG-13
  # And I uncheck the "G" checkbox
  # And I uncheck the "PG-13" checkbox
  # enter step to "submit" the search form on the homepage
  And I press "Refresh"
  # enter step(s) to ensure that PG and R movies are visible
  Then I should see "The Terminator"
  And I should see "When Harry Met Sally"
  And I should see "Amelie"
  And I should see "The Incredibles"
  And I should see "Raiders of the Lost Ark"
  # enter step(s) to ensure that other movies are not visible
  And I should not see "Aladdin"
  And I should not see "The Help "
  And I should not see "Chocolat"
  And I should not see "2001: A Space Odyssey"
  And I should not see "Chicken Run"
