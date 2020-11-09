class User < ActiveRecord::Base
    has_many :ratings
    has_many :movies, through: :ratings

    attr_accessor :username, :password

    @@all = []

    def initialize(username, password)
        @username = username
        @password = password
        @@all << self
    end

    def self.all
        @@all
    end

    def self.find_user(user, pass)
        self.all.find {|user| user.username == user && user.password == pass}
    end

end