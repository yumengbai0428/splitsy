require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "all_transactions_for_user" do

    User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
    Transaction.create(payer_email: 'a@g',payee_ email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
    Transaction.create(payer_email: 'a@g',payee_ email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
    Transaction.create(payer_email: 'b@g',payee_ email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
    Transaction.create(payer_email: 'd@g',payee_ email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
    
    context 'user exists' do
      it 'finds the user with the email' do
        expect(Transaction.find_user('a').pluck("description")).to include('d1')
        expect(Transaction.find_user('a').pluck("description")).to include('d2')
        expect(Transaction.find_user('a').pluck("description")).to include('d4')
      end
    end

  end
  describe "all_user_mails" do

    User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
    User.create(name: 'b', email: 'b@g', password: 'p2', default_currency: 'Yen')
    
    context 'user exists' do
      it 'finds the user with the email' do
        expect(Transaction.all_user_mails()).to include('a@g')
        expect(Transaction.all_user_mails()).to include('b@g')
        expect(Transaction.all_user_mails().count).to eq(2)
      end
    end

  end
end