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

  And I am on the Splitsy home page
  # Then 7 seed transactions should exist

Scenario: New user must be able to sign up
When I am on the welcome page
  Then I should be able to sign up as 'apple' with 'apple@gmail.com'

Scenario: Existing user must be able to login
When I login as aladdin
  Then I am on the Splitsy home page

Scenario: Existing user cannot sign up again
When I am on the welcome page
  Then I should not be able to sign up as 'aladdin' with 'aladdin@gmail.com' 
  Then I am on the welcome page

Scenario: Transactions of logged in user must be displayed
When I login as aladdin
 And I am on the Splitsy home page
   Then I should see all transactions of aladdin@gmail.com

Scenario: Adding and deleting transactions for a user
When I login as aladdin
  Then I am on the Splitsy home page
  Then I follow "Add new transaction"
  Then I create a transaction with details 'aladdin@gmail.com', 'aladdin@gmail.com', 'test', 'US dollar', '34', '50' 
  Then I am on the Splitsy home page

Scenario: I am logged in and I log out
When I login as aladdin
  Then I am on the Splitsy home page
  Then I follow "Logout"
  Then I am on the welcome page

Scenario: I want to edit an existing transaction
When I login as aladdin
  Then I am on the Splitsy home page
  Then I click on the first transaction learn more about
  Then I follow "Edit"
  Then I edit the field "Amount" with "70"
  Then I press "Update Transaction Info"
  Then I am on the Splitsy home page
