class Movie < ActiveRecord::Base
    has_many :ratings
    has_many :users, through: :ratings

    attr_accessor :title, :date

    @@all = []

    def initialize(title,date)
        @title = title
        @date = date
        @@all << self
    end

    def self.all
        @@all
    end

    def 
end