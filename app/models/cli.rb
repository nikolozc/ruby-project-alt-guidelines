require 'omdb'
require 'omdb/api'
require 'pry'
@@client = Omdb::Api::Client.new(api_key: "7ec462bb")

class CLI

    @@prompt = TTY::Prompt.new
    @@user = nil

    def welcome
        system('clear')
        display_menu = @@prompt.select("Welcome! Please Log In or Signup.", %w(Login Signup))
        case display_menu
        when "Login"
            self.login
        when "Signup"
            self.signup
        end
    end

    def login
        username = @@prompt.ask("Please enter a username")
        password = @@prompt.mask("Please enter password (0-9)")
        if User.find_by(username: username, password: password)
            puts "Welcome back #{username}!"
            sleep(5)
            main_menu
        else
            system('clear')
            puts "User not found, taking you back to the welcome screen"
            sleep(5)
            welcome
        end
    end

    def signup
        username = @@prompt.ask("Please enter a username")
        password = @@prompt.mask("Please enter password (0-9)")
        new_user = User.create(username: username, password: password)
        puts "Welcome and thanks for joining!"
        sleep(1)
        self.main_menu
    end
    
    def main_menu
        puts "Welcome to -------!"
        choices = ["Search for a movie to review", "See what movies you have rated already", "Browse a list of movies","Logout"]
        selection = @@prompt.select("What would you like to do today?", choices)
        case selection
        when "Search for a movie to review"
            self.search_for_movie
        when "See what movies you have rated already"
            self.rated_movies
        when "Browse a list of movies"
            self.movie_list
        when "Logout"
            self.logout
        end
    end

    def search_for_movie
        puts "Enter the movie you'd like to search for"
        movie_to_find = gets.chomp
        movies = @@client.find_by_title(movie_to_find)
        @@prompt.select("Please choose which movie you'd like to rate", (movies.title))
    end

    def self.rated_movies
        @@user.movies
    end

    def self.movie_list
        movies.title
    end

    def logout
        puts "Thanks for logging in! See you next time!"
        sleep(1)
        @@user = nil
        welcome
    end

end