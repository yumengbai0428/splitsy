require 'rails_helper'
require 'support/action_controller_workaround'

describe UsersController, :type => :controller do
    describe "UserController" do
        render_views
       
        context "validate a user" do
          before :each do
            user1 = User.create(id: 1, name: 'a', email: 'a@g', password: 'p1', default_currency: '$')
            user2 = User.create(id: 2,name: 'b', email: 'b@g', password: 'p2', default_currency: 'Yen')
          end
    
          it "user not exist" do
            get :validate, user: {"email": "c@g", "password": "p1"}
            expect(flash[:notice]).to eq("User login was invalid.")
            expect(response).to redirect_to('/welcome')
          end

          it "user exists and correct password" do
            get :validate, user: {"email": "a@g", "password": "p1"}
          
            expect(session[:user_email]).to eq("a@g")
            expect(response).to redirect_to(transactions_path)
          end

          it "user exists but incorrect password" do
            get :validate, user: {"email": "a@g", "password": "p2"}
          
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
            user1 = User.create(id: 1, name: 'a', email: 'a@g', password: 'p1', default_currency: '$')
            print(User.all)
          end
          it "Assigns a user" do
              get :show, user_email: 'a@g'
              expect(assigns(:user).name).to eq('a')
          end
       end
        context "create a user" do
            before :each do
              user1 = User.create(id: 1, name: 'a', email: 'a@g', password: 'p1', default_currency: '$')
              user2 = User.create(id: 2,name: 'b', email: 'b@g', password: 'p2', default_currency: 'Yen')
            end

            it "create new user" do
                get :create, user_params: {name: 'c', email: 'c@g', password: 'p3', default_currency: '$'}
                expect(session[:user_email]).to eq('c@g')
                expect(response).to redirect_to(transactions_path)
              end
        end




    end
end

