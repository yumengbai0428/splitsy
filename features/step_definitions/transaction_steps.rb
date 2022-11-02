# Add a declarative step here for populating the DB with movies.

Given /the following transactions exist/ do |transactions_table|
  transactions_table.hashes.each do |transaction|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Transaction.create(transaction)
  end
  # pending "Fill in this step in movie_steps.rb"
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

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  # pending "Fill in this step in movie_steps.rb"
  rating_list.split(',').each do |rating|
    step %(I #{uncheck}check "#{rating}")
  end
end

# Part 2, Step 3
Then /^I should (not )?see the following transactions: (.*)$/ do |no, transaction_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  transaction_list.split /,\s*/ do |transaction|
    step %(I should #{no}see "#{transaction}")
  end
end

Then /I should see all transactions of (.*)/ do |user_email|
  # Make sure that all the movies in the app are visible in the table
  @transaction_list = Transaction.all_transactions_for_user(user_email)
  expect(@transaction_list.count).to eq(5)
  
end

Given /I am logged in as (.*) with (.*)/ do |email, password|
  # Write code here that turns the phrase above into concrete actions
  click_button "Login"

  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Login"
end

Then /I should be able to add and delete a transaction from (.*) to (.*)/ do |payer_email, payee_email|
  # Write code here that turns the phrase above into concrete actions
  new_transaction = Transaction.create!(
    :payer_email => payer_email, 
    :payee_email => payee_email, 
    :description => 'Test transaction', 
    :currency => 'US dollar', 
    :amount => 1000, 
    :percentage => 0.5,
  )
  Transaction.destroy(new_transaction.id)
end

When /I login as (.*)/ do |user_name|
  # Write code here that turns the phrase above into concrete actions
  click_button "Login"

  email = 'aladdin@gmail.com'
  password = 'secretpass'

  @user = User.create!(
    :name => user_name,
    :email => email,
    :password => password,
  )

  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Login"
end

Then /I should be able to sign up/ do
  # Write code here that turns the phrase above into concrete actions
  click_button "Sign Up"

  email = 'apple@gmail.com'
  password = 'apple'
  name = 'apple'

  fill_in "Name", :with => name
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Create User"
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


# Then /complete the rest of of this scenario/ do
#   # This shows you what a basic cucumber scenario looks like.
#   # You should leave this block inside movie_steps, but replace
#   # the line in your scenarios with the appropriate steps.
#   fail "Remove this step from your .feature files"
# end
