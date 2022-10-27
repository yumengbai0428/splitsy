class TransactionsController < ApplicationController
    def show
        id = params[:id] # retrieve transaction ID from URI route
        @transaction = Transaction.find(id) # look up transaction by unique ID
        # will render app/views/transactions/show.<extension> by default
    end

    def destroy
        @transaction = Transaction.find(params[:id])
        @transaction.destroy
        flash[:notice] = "Transaction '#{@transaction.title}' deleted."
        redirect_to transactions_path
    end

    def edit
        @transaction = Transaction.find params[:id]
    end

    def create
        @transaction = Transaction.create!(transaction_params)
        flash[:notice] = "#{@transaction.text} was successfully created."
        redirect_to transactions_path
    end

    def update
        @transaction = Transaction.find params[:id]
        @transaction.update_attributes!(transaction_params)
        flash[:notice] = "#{@transaction.text} was successfully updated."
        redirect_to transaction_path(@transaction)
    end

    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def transaction_params
        params.require(:transaction).permit(:payer_email, :payee_email, :description, :currency, :amount, :percentage)
    end
end

