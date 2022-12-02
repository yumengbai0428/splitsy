require 'date'
class TransactionsController < ApplicationController
    before_action :check_login
    def show
        id = params[:id]
        @user = User.find_user(params[:user_email])
        @transaction = Transaction.find(id)
        @converted_amount = convert_amount
    end

    def check_login
        if session[:user_email] == nil
            flash[:notice] = "Invalid session, please login."
            redirect_to welcome_path
        end
    end

    def get_conv_factor(default_currency, transaction_currency)
        case default_currency
        when 'Canadian dollar'
            if transaction_currency == 'Yuan'
                conv_factor = 0.19
            elsif transaction_currency == 'Yen'
                conv_factor = 0.01
            elsif transaction_currency == 'US dollar'
                conv_factor = 1.34
            elsif transaction_currency == 'Euro'
                conv_factor = 1.41
            elsif transaction_currency == 'Rupee'
                conv_factor = 0.02
            else
                conv_factor = 1
            end
            #transaction_params['amount'] = Concurrency.convert(transaction_params['amount'], "CAD", "USD")
        when 'Yuan'
            if transaction_currency== 'Canadian dollar'
                conv_factor = 5.25
            elsif transaction_currency == 'Yen'
                conv_factor = 0.05
            elsif transaction_currency == 'US dollar'
                conv_factor = 7.04
            elsif transaction_currency == 'Euro'
                conv_factor = 7.42
            elsif transaction_currency == 'Rupee'
                conv_factor = 0.09
            else
                conv_factor = 1
            end
            #transaction_params['amount'] = Concurrency.convert(transaction_params['amount'], "CNY", "USD")
        when 'Rupee'
            if transaction_currency == 'Yuan'
                conv_factor = 11.52
            elsif transaction_currency == 'Yen'
                conv_factor = 0.60
            elsif transaction_currency == 'US dollar'
                conv_factor = 81.12
            elsif transaction_currency == 'Euro'
                conv_factor = 85.47
            elsif transaction_currency == 'Canadian dollar'
                conv_factor = 60.42
            else
                conv_factor = 1
            end
            #transaction_params['amount'] = Concurrency.convert(transaction_params['amount'], "INR", "USD")
        when 'Yen'
            if transaction_currency == 'Yuan'
                conv_factor = 19
            elsif transaction_currency == 'Canadian dollar'
                conv_factor = 101
            elsif transaction_currency == 'US dollar'
                conv_factor = 135
            elsif transaction_currency == 'Euro'
                conv_factor = 142
            elsif transaction_currency == 'Rupee'
                conv_factor = 2
            else
                conv_factor = 1
            end
            #transaction_params['amount'] = Concurrency.convert(transaction_params['amount'], "JPY", "USD")
        when 'Euro'
            if transaction_currency == 'Yuan'
                conv_factor = 0.13
            elsif transaction_currency == 'Yen'
                conv_factor = 0.01
            elsif transaction_currency == 'US dollar'
                conv_factor = 0.95
            elsif transaction_currency == 'Canadian dollar'
                conv_factor = 0.71
            elsif transaction_currency == 'Rupee'
                conv_factor = 0.01
            else
                conv_factor = 1
            end
            #transaction_params['amount'] = Concurrency.convert(transaction_params['amount'], "EUR", "USD")
        else
            if transaction_currency == 'Yuan'
                conv_factor = 0.14
            elsif transaction_currency == 'Yen'
                conv_factor = 0.01
            elsif transaction_currency == 'Canadian dollar'
                conv_factor = 0.74
            elsif transaction_currency == 'Euro'
                conv_factor = 1.05
            elsif transaction_currency == 'Rupee'
                conv_factor = 0.01
            else
                conv_factor = 1
            end
        end
        return conv_factor

    end

    def transform
        money_map = {}
        @total_dues = 0
        conv_factor = 1.0

        @transactions.each do |transaction|
            default_currency=User.where('email = ?', session[:user_email])[0].default_currency
            conv_factor = get_conv_factor(default_currency, transaction["currency"])

            payer = transaction['payer_email']
            payee = transaction['payee_email']
            is_payer = payer == session[:user_email]
            if is_payer
                @total_dues -= (transaction['amount']*(transaction['percentage'].to_f/100.0) * conv_factor).round(2)
                if not money_map.key?(payee)
                    money_map[payee] = -(transaction['amount']*(transaction['percentage'].to_f/100.0) * conv_factor).round(2)
                else 
                    money_map[payee] -= (transaction['amount']*(transaction['percentage'].to_f/100.0) * conv_factor).round(2)
                end
            else
                @total_dues += (transaction['amount']*(transaction['percentage'].to_f/100.0) * conv_factor).round(2)
                if not money_map.key?(payer)
                    money_map[payer] = (transaction['amount']*(transaction['percentage'].to_f/100.0) * conv_factor).round(2)
                else 
                    money_map[payer] +=(transaction['amount']*(transaction['percentage'].to_f/100.0) * conv_factor).round(2)
                end
            end
        end

        @repayments.each do |repayment|
            default_currency=User.where('email = ?', session[:user_email])[0].default_currency
            conv_factor = get_conv_factor(default_currency, repayment["currency"])

            payer = repayment['payer_email']
            payee = repayment['payee_email']
            is_payer = payer == session[:user_email]
            if is_payer
                @total_dues += (repayment['amount'] * conv_factor).round(2)
                if not money_map.key?(payee)
                    money_map[payee] =(repayment['amount'] * conv_factor).round(2)
                else 
                    money_map[payee] += (repayment['amount'] * conv_factor).round(2)
                end
            else
                @total_dues -= (repayment['amount'] * conv_factor).round(2)
                if not money_map.key?(payer)
                    money_map[payer] = -(repayment['amount'] * conv_factor).round(2)
                else 
                    money_map[payer] -=(repayment['amount']* conv_factor).round(2)
                end
            end
        end


        persons = []
        money_map.each do |key, value|
            pmap = {}
            pmap['email'] = key
            pmap['amount_due'] = value
            persons.push(pmap)
        end
        return persons
    end

    def index
        @user_email = session[:user_email]
        @transactions = Transaction.all_transactions_for_user(session[:user_email])
        @repayments = Repayment.all_repayment_for_user(session[:user_email])
        @persons = transform
    end

    def list
        @user_email = session[:user_email]
        filter_form = params["filter_form"]
        if filter_form.nil?
            @transactions = Transaction.all_transactions_for_user(session[:user_email])
        else 
            tag = params["filter_form"]["tag"]
            start_date = params["filter_form"]["start_date"]
            end_date = params["filter_form"]["end_date"]
            if (tag.nil? or tag.empty?) and (start_date.nil? or start_date.empty?) and (end_date.nil? or end_date.empty?)
                @transactions = Transaction.all_transactions_for_user(session[:user_email])
            else
                @transactions = Transaction.find_tansactions_tag_time(session[:user_email],  params["filter_form"]["tag"], params["filter_form"]["start_date"], params["filter_form"]["end_date"])
            end
        end
    end

    def destroy
        @transaction = Transaction.find(params[:id])
        @transaction.destroy
        flash[:notice] = "Transaction '#{@transaction.id}' deleted."
        redirect_to transactions_path
    end

    def new
        @users = Transaction.all_user_mails
    end

    def edit
        @users = Transaction.all_user_mails
        @transaction = Transaction.find params[:id]
    end

    def validate_create
        flag = false
        if transaction_params['payer_email'] != session[:user_email] and transaction_params['payee_email'] != session[:user_email]
            flash[:notice] = "Invalid transaction - payer or payee must be you."
        elsif transaction_params['payer_email'] == transaction_params['payee_email']
            flash[:notice] = "Invalid transaction - payer and payee cannot be the same user."
        elsif Date.iso8601(transaction_params['timestamp']) > Date.today
            flash[:notice] = "Invalid transaction - date cannot be in the future."
        else
            flag = true
        end
        return flag
    end

    def create
        if validate_create
            begin
                @transaction = Transaction.create!(transaction_params)
                flash[:notice] = "Transaction was successfully created."
            rescue ActiveRecord::RecordInvalid => invalid
                flash[:notice] = "Invalid transaction amount/percentage."
            end
        end
        redirect_to transactions_path
    end

    def update
        @transaction = Transaction.find params[:id]
        @transaction.update_attributes!(transaction_params)
        flash[:notice] = "#{@transaction.id} was successfully updated."
        redirect_to transaction_path(@transaction)
    end

    def convert_amount
        return @transaction.amount.to_s + " (" + @transaction.currency + ")"
    end

    def logout
        session[:user_email] = nil
        flash[:notice] = "User successfully logged out."
        redirect_to welcome_path
    end

    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def transaction_params
        params.require(:transaction).permit(:payer_email, :payee_email, :description, :currency, :amount, :percentage, :timestamp, :tag)
    end
end

