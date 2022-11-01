require 'rails_helper'

describe TransactionsController, :type => :controller do
  
  
  describe "TransactionsController" do
    render_views
   
    context "Showing a transaction" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
        @transactions = Transaction.all
      end

      it "Should be show a trasaction" do
        get :show, id: @transactions.take.id
        expect(assigns(:transaction)).to eq(@transactions.take)
        # todo:
        # test converted amount
      end

    end


    context "Creating Transactions" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
        @transactions = Transaction.all
      end

      it "Should be create a transaction" do

        transactions_count = Transaction.all.count
        transaction = {payer_email: 'c@g',payee_email: 'a@g', description: 'd5', currency: '$', amount: 20, percentage: 0.25}
        post :create, transaction: transaction
      
        expect(flash[:notice]).to eq("#{transaction.id} was successfully created.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count + 1)
      end

    end

    context "Editing a transaction" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
        @transactions = Transaction.all
      end

      it "Should be edit a transaction" do
        get :edit, id: @transactions.take.id
      
        expect(assigns(:transaction)).to eq(@transactions.take)
      end

    end


    context "Updating transactions" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
        @transactions = Transaction.all
      end

      it "Should be updating a transaction" do
        transaction = @transactions.take
        transaction_param = {description: 'd6'}
        put :update, id: transaction.id, transaction: transaction_param
      
        expect(flash[:notice]).to eq("#{transaction.id} was successfully updated.")
        expect(response).to redirect_to(transaction_path(transaction.id))
        expect(Transaction.find(transaction.id).description).to eq('d6')

      end

    end


    context "Destroy Transactions" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33)
        @transactions = Transaction.all
      end

      it "Should be destroy a transaction" do
        transactions_count = Transaction.all.count
        transaction = @transactions.take
        delete :destroy, id: transaction.id 
      
        expect(flash[:notice]).to eq("Transaction '#{transaction.id}' deleted.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count -1)
      end
    end
  end
end
