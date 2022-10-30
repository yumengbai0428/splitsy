class SessionsController < ApplicationController
    def create
        @user = User.find_by(email: params[:user_email])
        if !!@user && @user.authenticate(params[:password])
            sesstion[:user_email] = @user.email
            redirect_to root_path
        else
            message = "Make sure your username and password are valid."
            redirect_to login_path, notice: message
        end
    end
end