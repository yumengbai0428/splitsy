class Transaction < ActiveRecord::Base
    validates :amount, numericality: { greater_than: 0 }
    validates :percentage, numericality: { greater_than: 0 }
    def self.all_transactions_for_user(email)
        payer_trans = Transaction.where('payer_email = ?', email)
        payee_trans = Transaction.where('payee_email = ?', email)
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
