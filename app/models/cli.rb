require 'omdb'
require 'pry'

class CLI

    @@prompt = TTY::Prompt.new
    @@user = nil

    def self.prompt
        @@prompt
    end

    def self.user
        @@user
    end

    def welcome
        system('clear')
        display_menu = self.prompt.select("Welcome! Please Log In or Signup.", %w(Login Signup))
        case display_menu
        when "Login"
            self.login
        when "Signup"
            self.signup
        end
    end

    def self.login
        username = prompt.ask("Please enter a username")
        password = prompt.mask("Please enter password (0-9)")
        self.user = User.find_user(username,password)
        if self.user do
            puts "Welcome back #{user.username}!"
            sleep(1)
            self.main_menu
        else do
            puts "User not found, taking you back to the welcome screen"
            self.welcome
        end
    end

    def self.signup
        username = prompt.ask("Please enter a username")
        password = prompt.mask("Please enter password (0-9)")
        new_user = User.new(username: username, password: password)
        puts "Welcome and thanks for joining!"
        sleep(1)
        self.main_menu
    end
    
    def self.main_menu
        puts "Welcome to -------!"
        selection = prompt.select("What would you like to do today?") do |menu|
            menu.choice = "Search for a movie to review"
            menu.choice = "See what movies you have rated already"
            menu.choice = "Browse a list of movies"
            menu.choice = "Logout"
        end
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

    def self.search_for_movie
        puts "Enter the movie you'd like to search for"
        movie_to_find = gets.chomp
        movies = Omdb::Api.new.search(movie_to_find)
        prompt.select("Please choose which movie you'd like to rate" (movies[:movies].title))
    end

    def self.rated_movies
        
    end

    def self.movie_list

    end

    def self.logout
        self.user = nil
        self.welcome
    end

end