require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "all_transactions_for_user" do

    User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
    Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
    Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
    Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
    Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
    
    context 'user exists' do
      it 'finds the user with the email' do
        temp = Transaction.all_transactions_for_user('a@g')
        descriptions = []
        temp.each do |t|
          descriptions.push(t["description"])
        end
        expect(descriptions).to include('d1')
        expect(descriptions).to include('d2')
        expect(descriptions).to include('d4')
        expect(descriptions).to_not include('d3')
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