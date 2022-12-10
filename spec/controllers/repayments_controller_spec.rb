require 'rails_helper'

describe RepaymentsController, :type => :controller do
  
  
  describe "RepaymentsController" do
    render_views
    
    context "Creating Repayments" do
      before :each do
        User.create(name: 'a', email: 'a@g', password: 'p2', default_currency: 'Yen')
        User.create(name: 'b', email: 'b@g', password: 'p2', default_currency: 'Yen')
        Transaction.create(payer_email: 'b@g',payee_email: 'a@g', description: 'd1', currency: '$', amount: 100, percentage:100)
        @repayments = Repayment.all
      end

      it "Create repayment" do
        repayments_count = Repayment.all.count
        transaction = {payee_email: 'b@g', description: 'd5', currency: '$', amount: 20}
        post :create, {repayment: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Repayment was successfully created.")
        expect(response).to redirect_to(all_repayments_path)
        expect(@repayments.count).to eq(repayments_count+1)
      end

      it "Amount has to be non negative" do
        repayments_count = Repayment.all.count
        transaction = {payee_email: 'b@g', description: 'd5', currency: '$', amount: -20}
        post :create, {repayment: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Invalid repayment amount/percentage.")
      end

      it "Cannot pay more than owe" do
        repayments_count = Repayment.all.count
        transaction = {payee_email: 'b@g', description: 'd5', currency: '$', amount: 101}
        post :create, {repayment: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Invalid transaction - you can't repay more than what you owe")
      end

       it "Cannot pay more than owe" do
        repayments_count = Repayment.all.count
        transaction = {payee_email: 'b@g', description: 'd5', currency: '$', amount: 101}
        post :create, {repayment: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Invalid transaction - you can't repay more than what you owe")
      end

       it "Cannot repay yourself" do
        repayments_count = Repayment.all.count
        transaction = {payee_email: 'a@g', description: 'd5', currency: '$', amount: 10}
        post :create, {repayment: transaction}, {user_email: 'a@g'}
      
        expect(flash[:notice]).to eq("Invalid transaction - payer and payee cannot be the same user.")
      end

       it "Not logged in" do
        repayments_count = Repayment.all.count
        transaction = {payee_email: 'a@g', description: 'd5', currency: '$', amount: 10}
        post :create, {repayment: transaction}
      
        expect(flash[:notice]).to eq("Invalid session, please login.")
        expect(response).to redirect_to(welcome_path)
      end

    end

    context "New" do
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

    context "List" do
      before :each do
        Transaction.create(payer_email: 'b@g',payee_email: 'a@g', description: 'd1', currency: '$', amount: 100, percentage:100)
        Repayment.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd1', currency: '$', amount: 10)
        Repayment.create(payer_email: 'a@g',payee_email: 'b@g', description: 'd2', currency: '$', amount: 20)
      end
      it "Returns all emails of listed transactions" do
        get :list, {filter_form: {}}, {user_email: 'a@g'}
        expect(assigns(:repayments).count).to eq(2)
      end
    end

  end
end