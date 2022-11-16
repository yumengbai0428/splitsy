Feature: sign up and login into splitsy

  I am concerned about how much money I have spent
  So I want to sign up or login to Splitsy and manage my profile

Scenario: New user must be able to sign up
When I am on the welcome page
  Then I should be able to sign up as 'apple' with 'apple@gmail.com'
  Then I am on the Splitsy home page

Scenario: Existing user must be able to login
When I am on the welcome page
  Then I login as aladdin
  Then I am on the Splitsy home page

Scenario: Existing user cannot sign up again
When I am on the welcome page
  Then I should not be able to sign up as 'aladdin' with 'aladdin@gmail.com' 
  Then I am on the welcome page
  Then I should see 'User with email already exists.'

Scenario: I am logged in and I log out
When I am on the welcome page
  When I login as aladdin
  Then I am on the Splitsy home page
  Then I follow "Logout"
  Then I am on the welcome page

Scenario: I want to view my profile
When I am on the welcome page
  When I login as aladdin
  And I follow "My Profile"
  Then I should see 'Your Profile'

Scenario: I want to edit my profile
When I am on the welcome page
  When I login as aladdin
  And I follow "My Profile"
  And I follow "Edit"
  And I choose "Default Currency" as "Rupee"
  And I press "Update Your Info"
  Then I should see 'successfully updated'

Scenario: I want to cancel edit my profile
When I am on the welcome page
  When I login as aladdin
  And I follow "My Profile"
  And I follow "Edit"
  And I follow "Cancel"
  Then I am on the Splitsy home page 

Scenario: I try to access my profile without loggin in
When I try to check my profile 'aladdin@gmail.com'
  Then I am on the welcome page
  Then I should see 'Invalid session, please login.'

Scenario: I try to login to an account I haven't created
When I am on the welcome page
  Then I press "Login"
  Then I press "Login"
  Then I am on the welcome page
  Then I should see 'User does not exist.'

Scenario: I try to login with the incorrect password
When I am on the welcome page
  Then I press "Login"
  Then I fill my login details 'aladdin@gmail.com', 'test'
  Then I am on the welcome page
  Then I should see 'User login was invalid.'
