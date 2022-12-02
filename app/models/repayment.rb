class Repayment < ActiveRecord::Base

    validates :amount, numericality: { greater_than: 0 }
    def self.all_repayment_for_user(email)
        payer_trans = Repayment.where('payer_email = ?', email)
        payee_trans = Repayment.where('payee_email = ?', email)
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

    

end
