class User < ActiveRecord::Base
    has_many :ratings
    has_many :movies, through: :ratings

    def self.find_user(user, pass)
        self.all.find {|user| user.username == user && user.password == pass}
    end

end