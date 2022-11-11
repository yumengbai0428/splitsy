class Transaction < ActiveRecord::Base
    def self.all_transactions_for_user(email)
        payer_trans = Transaction.where('payer_email = ?', email)
        payee_trans = Transaction.where('payee_email = ?', email)
        all_trans = []
        if not payee_trans.nil?
            payer_trans.each do |t|
                all_trans.push(t)
            end
        end
        if not payee_trans.nil?
            payee_trans.each do |t|
                all_trans.push(t)
            end
        end
        return all_trans
    end

    def self.find_tansactions_by_tag(email, tag)
        payer_trans = Transaction.where('payer_email = ? and tag = ?', email, tag)
        payee_trans = Transaction.where('payee_email = ? and tag = ?', email, tag)
        all_trans = []
        if not payee_trans.nil?
            payer_trans.each do |t|
                all_trans.push(t)
            end
        end
        if not payee_trans.nil?
            payee_trans.each do |t|
                all_trans.push(t)
            end
        end
        return all_trans
    end

    def self.find_tansactions_during_time(email, start_time, end_time)
        payer_trans = Transaction.where('payer_email= ? and time >= ? and time<= ? ', email, start_time, end_time)
        payee_trans = Transaction.where('payee_email= ? and time >= ? and time<= ? ', email, start_time, end_time)
        all_trans = []
        if not payee_trans.nil?
            payer_trans.each do |t|
                all_trans.push(t)
            end
        end
        if not payee_trans.nil?
            payee_trans.each do |t|
                all_trans.push(t)
            end
        end
        return all_trans
    end

    def self.find_tansactions_tag_time(email, tag, start_time, end_time)
        payer_trans = Transaction.where('payer_email= ? and tag = ? and time >= ? and time<= ?', email, start_time, end_time)
        payee_trans = Transaction.where('payee_email= ? and tag = ? and time >= ? and time<= ?', email, start_time, end_time)
        all_trans = []
        if not payee_trans.nil?
            payer_trans.each do |t|
                all_trans.push(t)
            end
        end
        if not payee_trans.nil?
            payee_trans.each do |t|
                all_trans.push(t)
            end
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
