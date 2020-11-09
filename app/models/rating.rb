class Rating < ActiveRecord::Base
    belongs_to :user
    belongs_to :movie

    attr_accessor :user, :movie, :rating, :description

    @@all = []

    def initialize(user, movie, rating, description)
        @user = user
        @movie = movie
        @rating = rating
        @description = description
        @@all << self
    end

    def self.all
        @@all
    end

    

end