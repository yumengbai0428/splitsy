class Transaction < ActiveRecord::Base
    validates :amount, numericality: { greater_than: 0 }
    validates :percentage, numericality: { greater_than: 0 }
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

    def self.find_tansactions_tag_time(email, tag, start_time, end_time)
        if tag == ''
            if start_time == '' and end_time != ''
                payer_trans = Transaction.where('payer_email= ? and timestamp <= ?', email, end_time)
                payee_trans = Transaction.where('payee_email= ? and timestamp <= ?', email, end_time)
            elsif end_time == '' and start_time != ''
                payer_trans = Transaction.where('payer_email= ? and timestamp >= ?', email, start_time)
                payee_trans = Transaction.where('payee_email= ? and timestamp >= ?', email, start_time)
            else
                payer_trans = Transaction.where('payer_email= ? and timestamp >= ? and timestamp<= ?', email, start_time, end_time)
                payee_trans = Transaction.where('payee_email= ? and timestamp >= ? and timestamp<= ?', email, start_time, end_time)
            end
        else
            if start_time == '' and end_time != ''
                payer_trans = Transaction.where('payer_email= ? and tag = ? and timestamp<= ?', email, tag, end_time)
                payee_trans = Transaction.where('payee_email= ? and tag = ? and timestamp<= ?', email, tag, end_time)
            elsif end_time == '' and start_time != ''
                payer_trans = Transaction.where('payer_email= ? and tag = ? and timestamp>= ?', email, tag, start_time)
                payee_trans = Transaction.where('payee_email= ? and tag = ? and timestamp>= ?', email, tag, start_time)
            elsif start_time != '' and end_time != ''
                payer_trans = Transaction.where('tag = ? and payer_email= ? and timestamp >= ? and timestamp<= ?', tag, email, start_time, end_time)
                payee_trans = Transaction.where('tag = ? and payee_email= ? and timestamp >= ? and timestamp<= ?', tag, email, start_time, end_time)
            else
                payer_trans = Transaction.where('payer_email = ? and tag = ?', email, tag)
                payee_trans = Transaction.where('payee_email = ? and tag = ?', email, tag)
            end
        end
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

    def self.owe_money(payer_email, payee_email)
        payer_trans = Transaction.where('payer_email = ? and payee_email = ?', payer_email, payee_email)
        sum = 0
        if not payer_trans.nil?
            payer_trans.each do |t|
                sum -= t["amount"] * t["percentage"]
            end
        end
        payee_trans = Transaction.where('payer_email = ? and payee_email = ?', payee_email, payer_email)
        if not payee_trans.nil?
            payee_trans.each do |t|
                sum += t["amount"] * t["percentage"]
            end
        end
        return sum
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
