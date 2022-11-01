require 'rails_helper'

describe SessionsController, :type => :controller do
  
  
  describe "SessionsController" do
    render_views

    context "Creating a session" do
        before :each do
            User.create(name: 'a', email: 'a@g', password: 'p1', default_currency: 'Yen')
        end
  
        it "valid username and password" do
            post :create, user_email: 'a@g', password: 'p1'
            expect(session[:user_email]).to eq('a@g')
            expect(response).to redirect_to(transactions_path)
        end

        it "valid username and wrong password" do
            post :create, user_email: 'a@g', password: 'p2'
            expect(flash[:notice]).to eq("Invalid session, please login.")
            expect(response).to redirect_to(login_path)
        end

        it "invalid username" do
            post :create, user_email: 'b@g', password: 'p1'
            expect(flash[:notice]).to eq("Invalid session, please login.")
            expect(response).to redirect_to(login_path)
        end
  
      end


  end
end