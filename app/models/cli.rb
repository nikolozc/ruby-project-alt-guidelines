require 'omdb'
require 'omdb/api'
require 'pry'


class CLI

    @@client = Omdb::Api::Client.new(api_key: "7ec462bb")
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
            system('clear')
            puts "Welcome back #{username}!"
            sleep(1)
            self.main_menu
        else
            system('clear')
            puts "User not found, taking you back to the welcome screen"
            sleep(1)
            self.welcome
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
        binding.pry
        if movies.response == "True"
            new_movie = Movie.create({title: movies.title})
            selection = @@prompt.select("Please choose which movie you'd like to rate", (movies.title))
            if selection == movies.title
                rating = @@prompt.ask "What would you like to rate this movie? (0-5)"
                puts "Thanks for rating this movie! Taking you home.."
                Rating.create({user_id: @@user, movie_id: new_movie, rating: rating})
                sleep(0.5)
                binding.pry
                main_menu
            else
                main_menu
            end
        else
            puts "movie not found, try again"
            self.search_for_movie
        end
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