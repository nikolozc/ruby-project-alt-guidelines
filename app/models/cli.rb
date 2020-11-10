require 'omdb'
require 'omdb/api'
require 'pry'


class CLI

    #@@client = Omdb::Api::Client.new(api_key: "7ec462bb")
    @@prompt = TTY::Prompt.new
    @@artii = Artii::Base.new :font => 'slant'
    @@user = nil

    def logo
       puts @@artii.asciify("Welcome to")
       puts @@artii.asciify("miMovie!")
    end

    def welcome
        logo
        sleep(5)
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
        if user = User.find_by(username: username, password: password)
            @@user = user
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
        @@user = new_user
        puts "Welcome and thanks for joining!"
        sleep(1)
        self.main_menu
    end
    
    def main_menu
        system('clear')
        puts "Welcome to miMovie!"
        choices = ["Search for a movie to review", "See what movies you have rated already", "See a random movie!","Logout"]
        selection = @@prompt.select("What would you like to do today?", choices)
        case selection
        when "Search for a movie to review"
            self.search_for_movie
        when "See what movies you have rated already"
            self.rated_movies
        when "See a random movie!"
            self.random_movie
        when "Logout"
            self.logout
        end
    end

    def search_for_movie
        puts "Enter the movie you'd like to search for"
        movie_to_find = gets.chomp
        if Movie.all.include?(movie_to_find)
            movies = Movie.all.select{|movie|movie.title.include?(movie_to_find)}
            selection = @@prompt.select("Please choose which movie you'd like to rate", (movies.title))
            puts "What is the rating for this movie? (Ratings are scaled 1-5)"
            rating = gets.chomp
            while(rating < 1 || rating > 5) do
                puts "Invalid choice, please enter a number 1-5"
                rating = gets.chomp
            end
            Rating.create({user: @@user, movie: selection, rating: rating})
            puts "Your movie has been added to your list of Rated Movies"
            sleep (0.5)
            puts "Taking you back to the main menu.."
            main_menu
        else 
            puts "No movies found by that title, try again"
            self.search_for_movie
        end

        #movies = @@client.find_by_title(movie_to_find)
        #movie_title = movies.title
        #new_movie =Movie.create(title: movie_title)
        #selection = @@prompt.select("Please choose which movie you'd like to rate", (movie_title))
        #puts "What is the rating for this movie? (Ratings are scaled 1-5)"
        #rating = gets.chomp
        #Rating.create({user: @@user, movie: new_movie, rating: rating})
        #puts "Your movie has been added to your list of Rated Movies"
        #sleep (0.5)
        #puts "Taking you back to the main menu.."
        #main_menu
    end

    def rated_movies
        puts "Here are the movies you have rated already"
        sleep(1)
        selection = @@prompt.select("Please choose which movies rating you'd like to update", (@@user.movies))
        puts "What is the new rating for this movie?"
        rating = gets.chomp
        puts "The rating for this movie has been updated!"
        sleep (0.5)
        puts "Taking you back to the main menu.."
        main_menu
    end

    def random_movie
        Faker::Movie.title
    end

    def logout
        puts "Thanks for logging in! See you next time!"
        sleep(5)
        @@user = nil
        welcome
    end

end