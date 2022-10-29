require 'rails_helper'
require 'support/action_controller_workaround'

describe UsersController, :type => :controller do

    describe "GET 'index'" do
        context "index" do
            it "Shows all musers" do
                #get :index
                #expect(assigns(:users)).to eq(Users.all)
               pending "Users not implemented"  
          end
        end
    end
end

