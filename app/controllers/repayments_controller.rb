require 'date'
class RepaymentsController < ApplicationController
    before_action :check_login

    def check_login
        if session[:user_email] == nil
            flash[:notice] = "Invalid session, please login."
            redirect_to welcome_path
        end
    end


    def list
        @user_email = session[:user_email]
        filter_form = params["filter_form"]
        @repayments = Repayment.all_repayment_for_user(session[:user_email])
    end

    def new
        @users = Transaction.all_user_mails
    end

    def validate_repayment
        flag = false

        if session[:user_email] == params["repayment"]['payee_email']
            flash[:notice] = "Invalid transaction - payer and payee cannot be the same user."
        elsif params["repayment"]['amount'].to_i > Transaction.owe_money(session[:user_email], params["repayment"]['payee_email'])
           flash[:notice] = "Invalid transaction - you can't repay more than what you owe"
        else
            flag = true
        end
        return flag
    end

    def create
        if validate_repayment
            begin
                p = params["repayment"].clone
                p.merge!('payer_email': session[:user_email])
                p["amount"]=p["amount"].to_f

                p.permit!
                @repayment = Repayment.create!(p)
                flash[:notice] = "Repayment was successfully created."
            rescue ActiveRecord::RecordInvalid => invalid
                flash[:notice] = "Invalid repayment amount/percentage."
            end
        end
        redirect_to all_repayments_path
    end



    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def repayment_params
        params.require(:repayment).permit(:payer_email, :payee_email, :description, :currency, :amount)
    end
end

