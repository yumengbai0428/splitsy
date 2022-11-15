require 'rails_helper'
require 'support/action_controller_workaround'

describe UsersController, :type => :controller do
    describe "UserController" do
        render_views
       
        context "validate a user" do
          before :each do
            user1 = User.create(id: 1, name: 'a', email: 'a@columbia.edu', password: 'p1', default_currency: '$')
            user2 = User.create(id: 2,name: 'b', email: 'b@columbia.edu', password: 'p2', default_currency: 'Yen')
          end
    
          it "user not exist" do
            get :validate, user: {"email": "c@columbia.edu", "password": "p1"}
            expect(flash[:notice]).to eq("User login was invalid.")
            expect(response).to redirect_to('/welcome')
          end

          it "user has invalid email domain" do
            get :create, user: {"name": "test", "email":"c@gmail.com", "password": "p1"}
            expect(flash[:notice]).to eq("Invalid credentials.")
            expect(response).to redirect_to('/welcome')
          end

          it "user has invalid name and password" do
            get :create, user: {"name": "", "email":"c@gmail.com", "password": ""}
            expect(flash[:notice]).to eq("Invalid credentials.")
            expect(response).to redirect_to('/welcome')
          end

          it "user exists and correct password" do
            get :validate, user: {"email": "a@columbia.edu", "password": "p1"}
          
            expect(session[:user_email]).to eq("a@columbia.edu")
            expect(response).to redirect_to(transactions_path)
          end

          it "user exists but incorrect password" do
            get :validate, user: {"email": "a@columbia.edu", "password": "p2"}
          
            expect(flash[:notice]).to eq("User login was invalid.")
            expect(response).to redirect_to('/welcome')
          end

        end
        context "index" do
          it "Shows all users" do
              get :index
              expect(assigns(:users)).to eq(User.all)
          end
        end
        
        context "new blank user" do
          it "assigns a new user" do
            get :new
            expect(assigns(:user)).to be_a_new(User)
          end
        end

        context "show" do
          before :each do
            user1 = User.create(id: 1, name: 'a', email: 'a@columbia.edu', password: 'p1', default_currency: '$')
          end

          it "check_login for nil session" do
            get :show, nil, nil
            expect(flash[:notice]).to eq("Invalid session, please login.")
            expect(response).to redirect_to(welcome_path)
        end

          it "Assigns a user" do
              get :show, {user_email: 'a@g'}, {user_email: 'a@columbia.edu'}
              expect(assigns(:user).name).to eq('a')
          end
       end
        context "create a user" do
            before :each do
              user1 = User.create(id: 1, name: 'a', email: 'a@columbia.edu', password: 'p1', default_currency: '$')
              user2 = User.create(id: 2,name: 'b', email: 'b@columbia.edu', password: 'p2', default_currency: 'Yen')
            end

            it "create new user" do
                get :create, user: {name: 'c', email: 'c@columbia.edu', password: 'p3', default_currency: '$'}
                expect(session[:user_email]).to eq('c@columbia.edu')
                expect(response).to redirect_to(transactions_path)
            end

            it "create existing user" do
              get :create, user: {name: 'a', email: 'a@columbia.edu', password: 'p3', default_currency: '$'}
              expect(flash[:notice]).to eq("User with email already exists.")
              expect(response).to redirect_to(welcome_path)
            end
        end




    end
end

