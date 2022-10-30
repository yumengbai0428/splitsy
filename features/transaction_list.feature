Feature: display list of all transactions

  I am concerned about how much money I have spent
  So I want to see all the transactions

Background: transactions have been added to database

  Given the following transactions exist:
  | payer_email        | payee_email       | description           | currency       | amount | percentage |
  | aladdin@gmail.com  | bob@gmail.com     | Thai food for lunch   | US dollar      | 50     | 0.25       |
  | aladdin@gmail.com  | bob@gmail.com     | Concert               | US dollar      | 100    | 0.5        |
  | aladdin@gmail.com  | carla@gmail.com   | Bar                   | US dollar      | 20     | 0.75       |
  | david@gmail.com    | aladdin@gmail.com | School supplies       | US dollar      | 20     | 1          |
  | emma@gmail.com     | aladdin@gmail.com | Rent1                 | US dollar      | 2000   | 0.33       |
  | emma@gmail.com     | jack@gmail.com    | Rent2                 | US dollar      | 2000   | 0.33       |
  | emma@gmail.com     | iris@gmail.com    | Rent3                 | US dollar      | 2000   | 0.33       |

  # And  I am on the Splitsy home page
  # Then 7 seed transactions should exist

Scenario: Aladdin logged in

  Then I should see "Thai food for lunch"
  And I should see "Concert"
  And I should see "Bar"
  And I should see "School supplies"
  And I should see "Rent1"
  # enter step(s) to ensure that other movies are not visible
  And I should not see "Rent2"
  And I should not see "Rent3"
