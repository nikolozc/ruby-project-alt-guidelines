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
        puts "Welcome to miMovie!"
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

    @@rated_movies = {}

    def search_for_movie
        puts "Enter the movie you'd like to search for"
        movie_to_find = gets.chomp
        movies = @@client.find_by_title(movie_to_find)
        movie_title = movies.title
        selection = @@prompt.select("Please choose which movie you'd like to rate", (movie_title))
        puts "What is the rating for this movie? (Ratings are scaled 1-5)"
        rating = gets.chomp
        @@rated_movies[movie_title] = rating
        puts "Your movie has been added to your list of Rated Movies"
        sleep (0.5)
        puts "Taking you back to the main menu.."
        main_menu
    end

    def rated_movies
        puts "Here are the movies you have rated already"
        sleep(1)
        selection = @@prompt.select("Please choose which movies rating you'd like to update", (@@rated_movies))
        puts "What is the new rating for this movie?"
        rating = gets.chomp
        puts "The rating for this movie has been updated!"
        sleep (0.5)
        puts "Taking you back to the main menu.."
        main_menu
    end

    def self.movie_list
        movies.title
    end

    def logout
        puts "Thanks for logging in! See you next time!"
        sleep(5)
        @@user = nil
        welcome
    end

end