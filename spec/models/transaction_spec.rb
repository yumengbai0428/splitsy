require 'rails_helper'

RSpec.describe Transaction, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  context "all transactions for user" do
    it "lists transactions" do
       pending "incomplete function"
       #Transaction.all_transactions_for_user
    end
  end
  context "list all user mails" do
    it "lists mails" do
      mails = Transaction.all_user_mails
      expect(mails).to be_empty
    end
  end
end
