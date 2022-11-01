class UsersController < ApplicationController
    def index
        @users = User.all
    end

    def new
        @user = User.new
    end

    def create
        @user = User.create!({name: params["user"]["name"], email: params["user"]["email"], password: params["user"]["password"], default_currency: params["user"]["default_currency"]})
        
        if @user.save
            session[:user_email] = @user.email
            redirect_to transactions_path
        else
            render :new
        end
    end

    def show
        @user = User.find(params[:user_email])
    end

    def login
    end

    def validate
        user = User.find_user(params["user"]["email"])
        if user.size() != 0
            if user[0].password == params["user"]["password"]
                session[:user_email] = params["user"]["email"]
                redirect_to transactions_path
                return
            end
        end
        flash[:notice] = "User login was invalid."
        redirect_to welcome_path
    end


    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :default_currency)
    end

end