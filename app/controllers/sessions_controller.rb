class SessionsController < ApplicationController
    def create
        @user = User.find_by(email: params[:user_email])
        if !!@user && (@user.password == params[:password])
            session[:user_email] = @user.email
            redirect_to transactions_path
        else
            message = "Make sure your username and password are valid."
            flash[:notice] = "Invalid session, please login."
            redirect_to login_path
        end
    end
end