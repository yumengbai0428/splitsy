class Transaction < ActiveRecord::Base
    def all_transactions_for_user user_name
        @email = Users.where(name: user_name).pluck(:email)
        @payer_trans = Transactions.where(payer_email: email)
        @payee_trans = Transactions.where(payee_email: email)
    end
end
