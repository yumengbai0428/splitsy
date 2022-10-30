module ApplicationHelper
    def logged_in?
        !!session[:user_email]
    end

    def current_user
        @current_user ||= session[:user_email] if !!session[:user_email]
    end
end
