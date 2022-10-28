class Transaction < ActiveRecord::Base
    def all_transactions_for_user user_name
        # incomplete function
        @email = User.where(name: user_name).pluck(:email)
        @payer_trans = Transactions.where(payer_email: email)
        @payee_trans = Transactions.where(payee_email: email)
    end

    def self.all_user_mails
        # class method to get all user emails
        user_mails = []
        User.all.each do |u|
            user_mails.push(u.email)
        end
        return user_mails
    end
end
