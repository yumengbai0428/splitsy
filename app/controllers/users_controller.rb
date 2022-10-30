class UsersController < ApplicationController
    def index
        @users = Users.all
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

    private
    def user_params
        params.require(:user).permit(:name, :email, :password)
    end

end