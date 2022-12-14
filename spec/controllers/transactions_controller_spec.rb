require 'rails_helper'

describe TransactionsController, :type => :controller do
  
  
  describe "TransactionsController" do
    render_views
   

    context "Logout" do
      before :each do
        User.create(name: 'a', email: 'a@columbia.edu', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5)
        @transactions = Transaction.all
      end

      it "Should successfully log out" do
        get :logout, {id: @transactions.take.id}, {user_email: "a@columbia.edu"}
        expect(flash[:notice]).to eq("User successfully logged out.")
        expect(response).to redirect_to(welcome_path)
      end
    end

    context "Invalid Session" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5, timestamp:Time.new)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1, timestamp:Time.new)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75, timestamp:Time.new)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33, timestamp:Time.new)
        @transactions = Transaction.all
      end

      it "Should recognize an invalid session" do
        get :show, {id: @transactions.take.id}, {user_email: nil}
        expect(flash[:notice]).to eq("Invalid session, please login.")
        expect(response).to redirect_to(welcome_path)
      end
    end

    context "Showing a transaction" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'CAD')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: 'USD', amount: 100, percentage: 0.5, timestamp:Time.new)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: 'USD', amount: 50, percentage: 1, timestamp:Time.new)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: 'USD', amount: 200, percentage: 0.75, timestamp:Time.new)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: 'USD', amount: 300, percentage: 0.33, timestamp:Time.new)
        @transactions = Transaction.all
      end

      it "Should be show a trasaction" do
        get :show, {id: @transactions.take.id}, {user_email: 'a@g'}
        expect(assigns(:transaction)).to eq(@transactions.take)
      end

    end


    context "Creating Transactions" do
      before :each do
        User.create(name: 'a', email: 'c@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5, repeat_period: '0')
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1, repeat_period: '0')
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75, repeat_period: '0')
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33, repeat_period: '0')
        @transactions = Transaction.all
      end

      it "Cannot create an indirect transaction" do
        transactions_count = Transaction.all.count
        transaction = {payer_email: 'c@g',payee_email: 'd@g', description: 'd5', currency: 'USD', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}

        expect(flash[:notice]).to eq("Invalid transaction - payer or payee must be you.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count)
      end

      it "Cannot create a transaction with same payer payee" do
        transactions_count = Transaction.all.count
        transaction = {payer_email: 'a@g',payee_email: 'a@g', description: 'd5', currency: '$', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Invalid transaction - payer and payee cannot be the same user.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count)
      end

      it "Wrong percentage transaction" do
        transactions_count = Transaction.all.count
        transaction = {payer_email: 'c@g',payee_email: 'a@g', description: 'd5', currency: '$', amount: 20, percentage: -0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Invalid transaction amount/percentage.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count)
      end


      it "Wrong date transaction" do
        transactions_count = Transaction.all.count
        transaction = {payer_email: 'c@g',payee_email: 'a@g', description: 'd5', currency: '$', amount: 20, percentage: 0.25, timestamp:Date.tomorrow}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Invalid transaction - date cannot be in the future.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count)
      end


      it "Should be create a transaction" do

        transactions_count = Transaction.all.count
        transaction = {payer_email: 'c@g',payee_email: 'a@g', description: 'd5', currency: '$', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'c@g'}
      
        expect(flash[:notice]).to eq("Transaction was successfully created.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count + 1)
      end

      it "Wrong repeat period" do

        transactions_count = Transaction.all.count
        transaction = {payer_email: 'c@g',payee_email: 'a@g', description: 'd5', currency: '$', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: 'f'}
        post :create, {transaction: transaction}, {user_email: 'c@g'}
      
        expect(flash[:notice]).to eq("Invalid transaction - Repeat period should be a number.")
        expect(response).to redirect_to(transactions_path)
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
        get :edit, {id: @transactions.take.id}, {user_email: 'a@g'}
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
        put :update, {id: transaction.id, transaction: transaction_param}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("#{transaction.id} was successfully updated.")
        expect(response).to redirect_to(transaction_path(transaction.id))
        expect(Transaction.find(transaction.id).description).to eq('d6')
      end

    end

    context "New Transaction" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        User.create(name: 'b', email: 'b@g', password: 'p3', default_currency: 'usd')
        User.create(name: 'c', email: 'c@g', password: 'p4', default_currency: 'eur')
      end
      it "Returns all emails of listed transactions" do
        get :new, nil, {user_email: 'a@g'}
        expect(assigns(:users)).to eq(["a@g", "b@g", "c@g"])
      end
    end

    context "Index" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'JPY')
        User.create(name: 'b', email: 'b@g', password: 'p2', default_currency: 'CAD')
        User.create(name: 'c', email: 'c@g', password: 'p2', default_currency: 'INR')
        User.create(name: 'd', email: 'd@g', password: 'p2', default_currency: 'CNY')
        User.create(name: 'e', email: 'e@g', password: 'p2', default_currency: 'USD')
        User.create(name: 'f', email: 'f@g', password: 'p2', default_currency: 'EUR')
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: 'USD', amount: 100, percentage: 0.5, timestamp:Time.new)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd5', currency: 'USD', amount: 100, percentage: 0.5, timestamp:Time.new, repeat_period:nil)
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: 'USD', amount: 50, percentage: 1, timestamp:Time.new)
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: 'USD', amount: 200, percentage: 0.75, timestamp:Time.new)
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: 'USD', amount: 300, percentage: 0.33, timestamp:Time.new)
        @transactions = Transaction.all
      end
      
      it "Converts" do
        get :index,nil,  {user_email: 'a@g'}
        expect(session[:conv][0,4]).to eq("135.")
        get :index,nil,  {user_email: 'b@g'}
        expect(session[:conv][0,3]).to eq("1.3")
        get :index,nil,  {user_email: 'c@g'}
        expect(session[:conv][0,3]).to eq("82.")
        get :index,nil,  {user_email: 'd@g'}
        expect(session[:conv][0,2]).to eq("6.")
        get :index,nil,  {user_email: 'e@g'}
        expect(session[:conv][0,2]).to eq("6.")
        get :index,nil,  {user_email: 'f@g'}
        expect(session[:conv][0,2]).to eq("6.")
      end

      it "Repeats" do
        get :index,nil,  {user_email: 'a@g'}
        transaction = {payer_email: 'c@g',payee_email: 'a@g', description: 'd5', currency: 'USD', amount: 20, percentage: 0.25, timestamp:Date.yesterday, repeat_period: '2'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(5)
      end

      it "Repeats Null" do
        get :index,nil,  {user_email: 'a@g'}
        expect(Transaction.find(@transactions.take.id).repeat_period).to eq(0)
        expect(assigns(:transactions).size).to eq(3)
      end
      
      it "Contains the correct number of transations" do
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(3)
      end

      it "multipe new transactions 1" do
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(3)
        transaction = {payer_email: 'a@g',payee_email: 'd@g', description: 'd5', currency: 'USD', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(4)
        transaction = {payer_email: 'a@g',payee_email: 'b@g', description: 'd6', currency: 'USD', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(5)
      end

      it "multipe new transactions 2" do
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(3)
        transaction = {payer_email: 'd@g',payee_email: 'a@g', description: 'd5', currency: 'USD', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(4)
        transaction = {payer_email: 'b@g',payee_email: 'a@g', description: 'd6', currency: 'USD', amount: 20, percentage: 0.25, timestamp:Date.today, repeat_period: '0'}
        post :create, {transaction: transaction}, {user_email: 'a@g'}
        get :index,nil,  {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(5)
      end
    end

    context "list" do
      before :each do
        Transaction.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 100, percentage: 0.5, tag: 'food', timestamp: '2022-11-11')
        Transaction.create(payer_email: 'a@g',payee_email: 'c@g', description: 'd2', currency: '$', amount: 50, percentage: 1, tag: 'expenditure', timestamp: '2022-11-12')
        Transaction.create(payer_email: 'b@g',payee_email: 'c@g', description: 'd3', currency: '$', amount: 200, percentage: 0.75, tag: 'expenditure', timestamp: '2022-11-11')
        Transaction.create(payer_email: 'd@g',payee_email: 'a@g', description: 'd4', currency: '$', amount: 300, percentage: 0.33, tag: 'expenditure', timestamp: '2022-11-11')
      end
      it "no parameter" do
        get :list, {filter_form: nil}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(3)
      end

      it "all nil" do
        get :list, {filter_form:{tag: "", start_date: "", end_date:"" }}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(3)
      end

      it "only tag" do
        get :list, {filter_form:{tag: 'expenditure', start_date: '', end_date:''}}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(2)
      end

      it "only start time" do
        get :list, {filter_form:{tag: '', start_date: '2022-11-11', end_date:''}}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(3)
      end

      it "only end time" do
        get :list, {filter_form:{tag: '', end_date: '2022-12-13', start_date:''}}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(3)
      end

      it "start and end time" do
        get :list, {filter_form:{tag: '', start_date: '2022-11-11', end_date:'2022-11-12'}}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(2)
      end

      it "end time and tag" do
        get :list, {filter_form:{tag: 'expenditure', start_date: '', end_date:'2022-11-12'}}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(1)
      end

      it "start time and tag" do
        get :list, {filter_form:{tag: 'expenditure', start_date: '2022-11-12', end_date:''}}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(1)
      end

      it "time and tag" do
        get :list, {filter_form:{tag: 'expenditure', start_date: '2022-11-11', end_date:'2022-11-12'}}, {user_email: 'a@g'}
        expect(assigns(:transactions).size).to eq(1)
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
        delete :destroy, {id: transaction.id}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Transaction '#{transaction.id}' deleted.")
        expect(response).to redirect_to(transactions_path)
        expect(@transactions.count).to eq(transactions_count -1)
      end
    end
  end
end
