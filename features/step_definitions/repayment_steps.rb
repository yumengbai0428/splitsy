Given /the following repayments exist/ do |repayments_table|
  repayments_table.hashes.each do |repayment|
    Repayment.create(repayment)
  end
end

Then /(.*) seed repayments should exist/ do | n_seeds |
  expect(Repayment.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /^I should (not )?see the following repayments: (.*)$/ do |no, repayment_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  repayment_list.split /,\s*/ do |repayment|
    step %(I should #{no}see "#{repayment}")
  end
end

Then /I should see all repayments of (.*)/ do |user_email|
  @repayment_list = Repayment.all_repayment_for_user(user_email)
  expect(@repayment_list.count).to eq(3)
  
end

Then /I should be able to add and delete a repayment from (.*) to (.*)/ do |payer_email, payee_email|
  new_repayment = Repayment.create!(
    :payer_email => payer_email, 
    :payee_email => payee_email, 
    :description => 'Test repayment', 
    :currency => 'US dollar', 
    :amount => 1000, 
    :percentage => 0.5,
  )
  Repayment.destroy(new_repayment.id)
end

Then /I create a repayment with details '(.*)', '(.*)', '(.*)', '(.*)'/ do |payee_email, description, currency, amount|
  count = Repayment.all.size()
  select payee_email, :from => "Payee Email"
  fill_in "Description", :with => description
  select currency, :from => "Currency"
  fill_in "Amount", :with => amount
  click_button "Save Changes"
  expect Repayment.all.size() == count + 1
end

Then /I create new repayment with details '(.*)', '(.*)', '(.*)', '(.*)'/ do |payee_email, description, currency, amount|
  select(payee_email, from: "Payee Email")
  fill_in "Description", :with => description
  select currency, :from => "Currency"
  fill_in "Amount", :with => amount
  click_button "Save Changes"
end


#Then /I should see all the repayments/ do
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
