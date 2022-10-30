class UsersController < ApplicationController
    def index
        @users = User.all
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_email] = @user.email
            redirect_to root_path
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
        User.all.each do |u|
            if params["user"]["email"] == u.email and params["user"]["password"] == u.password
                session[:user_email] = u.email
                redirect_to root_path
                return
            end
        end
        flash[:notice] = "User login was invalid."
        redirect_to welcome_path
    end

    private
    def user_params
        params.require(:user).permit(:name, :email, :password)
    end

end