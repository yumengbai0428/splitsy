require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "all_transactions_for_user" do
    before :each do
      User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
      Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
      Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
      Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
      Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
      @transactions = Transaction.all
    end

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

  describe "all_transactions_by_tag" do
    before :each do
      User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
      Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5, tag: 'food')
      Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
      Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
      Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
      @transactions = Transaction.all
    end
    
    context 'check default tag' do
      it 'finds transactions with tag expenditure' do
        temp = Transaction.find_tansactions_tag_time('a@g', 'expenditure', '', '')
        descriptions = []
        temp.each do |t|
          descriptions.push(t["description"])
        end
        expect(descriptions).to_not include('d1')
        expect(descriptions).to include('d2')
        expect(descriptions).to include('d4')
        expect(descriptions).to_not include('d3')
      end
    end
  end

  describe "all_transactions_by_time" do
    before :each do
      User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
      Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5, timestamp: '2022-11-11')
      Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1, timestamp: '2022-11-13')
      Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75, timestamp: '2022-11-12')
      Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33, timestamp: '2022-11-11')
      @transactions = Transaction.all
    end
    
    context 'check default tag' do
      it 'finds transactions with tag expenditure' do
        temp = Transaction.find_tansactions_tag_time('a@g', '', '2022-11-11', '2022-11-13')
        descriptions = []
        temp.each do |t|
          descriptions.push(t["description"])
        end
        expect(descriptions).to include('d1')
        expect(descriptions).to_not include('d2')
        expect(descriptions).to_not include('d3')
        expect(descriptions).to include('d4')
      end
    end
  end

  describe "all_transactions_tag_time" do
    before :each do
      User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
      Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5, timestamp: '2022-11-11')
      Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1, timestamp: '2022-11-13')
      Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75, timestamp: '2022-11-12')
      Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33, tag: 'food', timestamp: '2022-11-11')
      Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd5', currency: '$', amount: 300, percentage: 0.33, timestamp: '2022-11-11')
      @transactions = Transaction.all
    end
    
    context 'check default tag' do
      it 'finds transactions with tag expenditure' do
        temp = Transaction.find_tansactions_tag_time('a@g', 'expenditure', '2022-11-11', '2022-11-13')
        descriptions = []
        temp.each do |t|
          descriptions.push(t["description"])
        end
        expect(descriptions).to include('d1')
        expect(descriptions).to_not include('d2')
        expect(descriptions).to_not include('d3')
        expect(descriptions).to_not include('d4')
        expect(descriptions).to include('d5')
      end
    end
  end

  describe "all_user_mails" do
    before :each do
      User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
      User.create(name: 'b', email: 'b@g', password: 'p2', default_currency: 'Yen')
    end
    context 'user exists' do
      it 'finds the user with the email' do
        expect(Transaction.all_user_mails()).to include('a@g')
        expect(Transaction.all_user_mails()).to include('b@g')
        expect(Transaction.all_user_mails().count).to eq(2)
      end
    end

  end

  describe "owe money" do
    before :each do
      Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
      Transaction.create(payer_email: 'b@g',payee_email: 'a@g', description: 'd2', currency: '$', amount: 50, percentage: 0.5)
      Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
      Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
      Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
    end

    context 'owe money' do
      it 'finds the correct amount' do
        amount = Transaction.owe_money('a@g', 'b@g')
        expect(amount).to eq(-25)
      end

      it 'finds the correct amount2' do
        amount = Transaction.owe_money('b@g', 'a@g')
        expect(amount).to eq(25)
      end

      it 'finds the correct amount3' do
        amount = Transaction.owe_money('c@g', 'a@g')
        expect(amount).to eq(50)
      end

      it 'finds the correct amount4' do
        amount = Transaction.owe_money('a@g', 'c@g')
        expect(amount).to eq(-50)
      end
      
    end
  end
end
