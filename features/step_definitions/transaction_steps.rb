Given /the following transactions exist/ do |transactions_table|
  transactions_table.hashes.each do |transaction|
    transaction["timestamp"] = Time.now()
    Transaction.create(transaction)
  end
end

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create(user)
  end
end

Then /(.*) seed transactions should exist/ do | n_seeds |
  expect(Transaction.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # pending "Fill in this step in movie_steps.rb"
  expect(page.body.index(e1)).to be < page.body.index(e2)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rating|
    step %(I #{uncheck}check "#{rating}")
  end
end

Then /^I should (not )?see the following transactions: (.*)$/ do |no, transaction_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  transaction_list.split /,\s*/ do |transaction|
    step %(I should #{no}see "#{transaction}")
  end
end

Then /I should see all transactions of (.*)/ do |user_email|
  @transaction_list = Transaction.all_transactions_for_user(user_email)
  expect(@transaction_list.count).to eq(5)
  
end

Given /I am logged in as (.*) with (.*)/ do |email, password|
  click_button "Login"

  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Login"
end

Then /I should be able to add and delete a transaction from (.*) to (.*)/ do |payer_email, payee_email|
  new_transaction = Transaction.create!(
    :payer_email => payer_email, 
    :payee_email => payee_email, 
    :description => 'Test transaction', 
    :currency => 'USD', 
    :amount => 1000, 
    :percentage => 0.5,
  )
  Transaction.destroy(new_transaction.id)
end

When /I login as (.*)/ do |user_name|
  click_button "Login"

  email = 'aladdin@columbia.edu'
  password = 'password'

  @user = User.create!(
    :name => user_name,
    :email => email,
    :password => password,
  )

  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Login"
  expect page.body.include? "Transactions Summary"
end

Then /I should be able to sign up as '(.*)' with '(.*)'/ do |name, email|
  click_button "Sign Up"
  password = 'apple'

  fill_in "Name", :with => name
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Create User"
end

Then('I should not be sign up as {string} with wrong password') do |email|
  click_button "Login"

  fill_in "Email", :with => name
  fill_in "Password", :with => '12345'

  click_button "Login"
  expect page.body.include? "invalid"

end

Then /I should not be able to sign up as '(.*)' with '(.*)'/ do |name, email|
  click_button "Sign Up"
  password = 'apple'

  @user = User.create!(
    :name => name,
    :email => email,
    :password => password,
  )

  fill_in "Name", :with => name
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Create User"
  expect page.body.include? "User with email already exists"
end

Then /I try to check my profile '(.*)'/ do |email_id|
  visit path_to("user page of " + email_id)
end

Then /I fill my login details '(.*)', '(.*)'/ do |email_id, password| 
  fill_in "Email", :with => email_id
  fill_in "Password", :with => password
  click_button "Login"
end

Then /I create a transaction with details '(.*)', '(.*)', '(.*)', '(.*)', '(.*)', '(.*)'/ do |payer_email, payee_email, description, currency, amount, percentage|
  count = Transaction.all.size()
  select payer_email, :from => "Payer Email"
  select payee_email, :from => "Payee Email"
  fill_in "Description", :with => description
  select currency, :from => "Currency"
  fill_in "Amount", :with => amount
  fill_in "Percentage split", :with => percentage
  click_button "Save Changes"
  expect Transaction.all.size() == count + 1
end

Then /I create new transaction with details '(.*)', '(.*)', '(.*)', '(.*)', '(.*)', '(.*)'/ do |payer_email, payee_email, description, currency, amount, percentage|
  select(payer_email, from: "Payer Email")
  select(payee_email, from: "Payee Email")
  fill_in "Description", :with => description
  select currency, :from => "Currency"
  fill_in "Amount", :with => amount
  fill_in "Percentage split", :with => percentage
  click_button "Save Changes"
end

Then /I fill with details '(.*)', '(.*)', '(.*)', '(.*)', '(.*)', '(.*)', '(.*)'/ do |payer_email, payee_email, description, currency, amount, percentage, date|
  select(payer_email, from: "Payer Email")
  select(payee_email, from: "Payee Email")
  fill_in "Description", :with => description
  select currency, :from => "Currency"
  fill_in "Amount", :with => amount
  fill_in "Percentage split", :with => percentage
  fill_in "Date", :with => date
  click_button "Save Changes"
end

Then /I click on the first transaction learn more about/ do
  click_link("More about this transaction", match: :first)
end

Then /I edit the field "(.*)" with "(.*)"/ do |field_name, new_value|
  fill_in field_name, :with => new_value
end

Then('I should see {int} transactions from {string} to {string}') do |num_transactions, date1, date2|
  fill_in 'Start date', :with => date1
  fill_in 'End date', :with => date2

  click_button 'Search'
  expect Transaction.all.size() == num_transactions
end

Then('I should see {int} transactions with tag {string}') do |num_transactions, tag|
  fill_in 'Tag', :with => tag
  click_button 'Search'
  expect Transaction.all.size() == num_transactions
end

Then('I should see {int} transactions from {string} to {string} with tag {string}') do |num_transactions, date1, date2, tag|
  fill_in 'Tag', :with => tag

  fill_in 'Start date', :with => date1
  fill_in 'End date', :with => date2

  click_button 'Search'
  expect Transaction.all.size() == num_transactions
end

Then('I should see {string}') do |string|
  expect page.body.include? string
end

When('I choose {string} as {string}') do |string, string2|
  select string2, :from => string
end

When('I prompt {string}') do |string|
  accept_confirm("Are you sure?") do
    click_link(string)
  end
end

#Then /I should see all the transactions/ do
  # Make sure that all the movies in the app are visible in the table
#  expect(page).to have_xpath(".//tr[not(ancestor::thead)]", count: Transaction.count)
#end

### Utility Steps Just for this assignment.

Then /^debug$/ do
  # Use this to write "Then debug" in your scenario to open a console.
   require "byebug"; byebug
  1 # intentionally force debugger context in this method
end

Then /^debug javascript$/ do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end
