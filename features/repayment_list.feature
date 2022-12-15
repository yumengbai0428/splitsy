Feature: display list of all repayments

  I am concerned about how much money I have spent
  So I want to see all the transactions

Background: repayments have been added to database

  Given the following transactions exist:
  | payer_email           | payee_email          | description           | currency       | amount | percentage | repeat_period |
  | aladdin@columbia.edu  | bob@columbia.edu     | Thai food for lunch   | USD            | 50     | 25       | 0               |
  | aladdin@columbia.edu  | bob@columbia.edu     | Concert               | USD            | 100    | 50       | 0               |
  | aladdin@columbia.edu  | carla@columbia.edu   | Bar                   | USD            | 20     | 75       | 0               |
  | david@columbia.edu    | aladdin@columbia.edu | School supplies       | USD            | 20     | 100      | 0               |
  | emma@columbia.edu     | aladdin@columbia.edu | Rent1                 | USD            | 2000   | 33       | 0               |
  | emma@columbia.edu     | jack@columbia.edu    | Rent2                 | USD            | 2000   | 33       | 0               |
  | emma@columbia.edu     | iris@columbia.edu    | Rent3                 | USD            | 2000   | 33       | 0               |

  Given the following repayments exist:
  | payer_email           | payee_email          | currency   | amount  | description         |created_at                        |updated_at
  | aladdin@columbia.edu  | bob@columbia.edu     | USD        | 1       | Thai food for lunch |2022-12-15 15:23:33.125094 -0500  |2022-12-15 15:23:33.125094 -0500
  | david@columbia.edu    | aladdin@columbia.edu | USD        | 1       | School supplies     |2022-12-15 15:23:33.125094 -0500  |2022-12-15 15:23:33.125094 -0500
  | emma@columbia.edu     | aladdin@columbia.edu | USD        | 1       | Rent1               |2022-12-15 15:23:33.125094 -0500  |2022-12-15 15:23:33.125094 -0500
  | emma@columbia.edu     | jack@columbia.edu    | USD        | 1       | Rent2               |2022-12-15 15:23:33.125094 -0500  |2022-12-15 15:23:33.125094 -0500

  Given the following users exist:
  | name   | email               | password     | default_currency      
  | Bob    | bob@columbia.edu    | password     | USD
  | Carla  | carla@columbia.edu  | password     | USD
  | David  | david@columbia.edu  | password     | USD
  | Emma   | emma@columbia.edu   | password     | USD

  And I am on the Splitsy home page

Scenario: Repayments of logged in user must be displayed
When I login as aladdin
 And I am on the Splitsy home page
  And I follow "View all repayments"
   Then I should see all repayments of aladdin@columbia.edu

Scenario: I want to add a new repayment
When I login as aladdin
  And I follow "Add new repayment"
  And I create a repayment with details 'david@columbia.edu', 'Korean Food', 'USD', '2' 
  Then I should see 'successfully created'

Scenario: For a new repayment, payee must not be you
When I login as aladdin
  And I am on the Splitsy home page
  And I follow "Add new repayment"
  And I create new repayment with details 'aladdin@columbia.edu', 'test', 'USD', '2'
  Then I should see 'Invalid transaction'

Scenario: You cannot repay more than what you owe
When I login as aladdin
  And I am on the Splitsy home page
  And I follow "Add new repayment"
  And I create new repayment with details 'bob@columbia.edu', 'test', 'USD', '-34'
  Then I should see 'Invalid'

Scenario: For a new repayment, amount cannot be negative
When I login as aladdin
  And I am on the Splitsy home page
  And I follow "Add new repayment"
  And I create new repayment with details 'david@columbia.edu', 'test', 'USD', '-34'
  Then I should see 'Invalid'
