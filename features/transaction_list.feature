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

Scenario: I want to add new transaction for a user
When I login as aladdin
  Then I am on the Splitsy home page
  Then I follow "Add new transaction"
  Then I create a transaction with details 'aladdin@gmail.com', 'aladdin@gmail.com', 'test', 'US dollar', '34', '50' 
  Then I am on the Splitsy home page

Scenario: I want to validate new transaction
When I login as aladdin
  And I am on the Splitsy home page
  And I follow "Add new transaction"
  And I create new transaction with details 'aladdin@gmail.com', 'aladdin@gmail.com', 'test', 'US dollar', '-34', '50'
  Then I should see 'Invalid transaction'

Scenario: I want to delete transaction for a user
When I login as aladdin
  And I follow "View all transactions"
  And I click on the first transaction learn more about
  And I prompt "Delete"
  Then I should see 'deleted'

Scenario: I am logged in and I log out
When I login as aladdin
  Then I am on the Splitsy home page
  Then I follow "Logout"
  Then I am on the welcome page

Scenario: I want to edit an existing transaction
When I login as aladdin
  And I follow "View all transactions"
  And I click on the first transaction learn more about
  And I follow "Edit"
  And I edit the field "Amount" with "70"
  And I press "Update Transaction Info"
  Then I am on the Splitsy home page

Scenario: I want to filter trasactions by date
When I login as aladdin
  And I follow "View all transactions"
  Then I should see 5 transactions from '01/01/1990' to '11/01/2022'

Scenario: I want to filter trasactions by tag
When I login as aladdin
  And I follow "View all transactions"
  Then I should see 1 transactions with tag 'Bar'

Scenario: I want to filter transactions by tag and date
When I login as aladdin
  And I follow "View all transactions"
  Then I should see 1 transactions from '1/1/1990' to '11/01/2022' with tag 'Bar'

Scenario: I want to view my profile
When I login as aladdin
  And I follow "My Profile"
  Then I should see 'Your Profile'

Scenario: I want to edit my profile
When I login as aladdin
  And I follow "My Profile"
  And I follow "Edit"
  And I choose "Default Currency" as "Rupee"
  And I press "Update Your Info"
  Then I should see 'successfully updated'

Scenario: I want to cancel edit my profile
When I login as aladdin
  And I follow "My Profile"
  And I follow "Edit"
  And I follow "Cancel"
  Then I am on the Splitsy home page 
