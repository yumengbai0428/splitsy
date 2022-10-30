class Transaction < ActiveRecord::Base
    def self.all_transactions_for_user user_name
        # incomplete function
        email = User.where(name: user_name).distinct.pluck(:email)[0]
        payer_trans = Transaction.where(payer_email: email)
        print(payer_trans)
        payee_trans = Transaction.where(payee_email: email)
        all_trans = []
        payer_trans.each do |t|
            all_trans.push(t)
        end
        payee_trans.each do |t|
            all_trans.push(t)
        end
        return all_trans
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
