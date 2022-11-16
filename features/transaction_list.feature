Feature: display list of all transactions

  I am concerned about how much money I have spent
  So I want to see all the transactions

Background: transactions have been added to database

  Given the following transactions exist:
  | payer_email           | payee_email          | description           | currency       | amount | percentage |
  | aladdin@columbia.edu  | bob@columbia.edu     | Thai food for lunch   | US dollar      | 50     | 0.25       |
  | aladdin@columbia.edu  | bob@columbia.edu     | Concert               | US dollar      | 100    | 0.5        |
  | aladdin@columbia.edu  | carla@columbia.edu   | Bar                   | US dollar      | 20     | 0.75       |
  | david@columbia.edu    | aladdin@columbia.edu | School supplies       | US dollar      | 20     | 1          |
  | emma@columbia.edu     | aladdin@columbia.edu | Rent1                 | US dollar      | 2000   | 0.33       |
  | emma@columbia.edu     | jack@columbia.edu    | Rent2                 | US dollar      | 2000   | 0.33       |
  | emma@columbia.edu     | iris@columbia.edu    | Rent3                 | US dollar      | 2000   | 0.33       |

  And I am on the Splitsy home page

Scenario: Transactions of logged in user must be displayed
When I login as aladdin
 And I am on the Splitsy home page
   Then I should see all transactions of aladdin@columbia.edu

Scenario: I want to add new transaction for a user
When I login as aladdin
  Then I am on the Splitsy home page
  Then I follow "Add new transaction"
  Then I create a transaction with details 'aladdin@columbia.edu', 'aladdin@columbia.edu', 'test', 'US dollar', '34', '50' 
  Then I am on the Splitsy home page

Scenario: I want to validate new transaction
When I login as aladdin
  And I am on the Splitsy home page
  And I follow "Add new transaction"
  And I create new transaction with details 'aladdin@columbia.edu', 'aladdin@columbia.edu', 'test', 'US dollar', '-34', '50'
  Then I should see 'Invalid transaction'

Scenario: I want to delete transaction for a user
When I login as aladdin
  And I follow "View all transactions"
  And I click on the first transaction learn more about
  And I prompt "Delete"
  Then I should see 'deleted'

Scenario: I am logged in and I log out
When I login as aladdin
  And I am on the Splitsy home page
  And I follow "Add new transaction"
  And I create new transaction with details 'aladdin@columbia.edu', 'aladdin@columbia.edu', 'test', 'US dollar', '-34', '50'
  Then I should see 'Invalid transaction'

Scenario: I want to delete transaction for a user
When I login as aladdin
  And I follow "View all transactions"
  And I click on the first transaction learn more about
  And I prompt "Delete"
  Then I should see 'deleted'

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
  Then I should see 5 transactions from '1990-01-01' to '2022-01-01'

Scenario: I want to filter trasactions by tag
When I login as aladdin
  And I follow "View all transactions"
  Then I should see 1 transactions with tag 'Bar'

Scenario: I want to filter transactions by tag and date
When I login as aladdin
  And I follow "View all transactions"
  Then I should see 1 transactions from '1990-01-01' to '2022-01-01' with tag 'Bar' 

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

