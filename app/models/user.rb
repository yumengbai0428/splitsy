class User < ActiveRecord::Base
    validates :email, uniqueness: true
    def self.find_user(email)
        User.where('email = ?', email)
    end
end
