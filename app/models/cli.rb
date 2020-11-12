#require 'omdb'
#require 'omdb/api'
require 'pry'


class CLI

    #@@client = Omdb::Api::Client.new(api_key: "7ec462bb")
    @@prompt = TTY::Prompt.new
    #@@artii = Artii::Base.new :font => 'slant'
    @@user = nil
    @@spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)
    @@pastel = Pastel.new
    @@font = TTY::Font.new("3d")

    def logo
        puts @@pastel.cyan(@@font.write('miMovie'))
    end

    def welcome
        system('clear')
        logo
        #sleep(2)
        display_menu = @@prompt.select("Welcome! Please Log In or Signup.", %w(Login Signup))
        case display_menu
        when "Login"
            self.login
        when "Signup"
            self.signup
        end
    end

    def login
        system('clear')
        logo
        username = @@prompt.ask("Please enter a username").capitalize
        password = @@prompt.mask("Please enter password (0-9)")
        if user = User.find_by(username: username, password: password)
            @@user = user
            spinner
            puts "Welcome back #{username}!"
            sleep(2)
            self.main_menu
        else
            spinner
            puts "User not found, taking you back to the welcome screen"
            sleep(1)
            self.welcome
        end
    end

    def signup
        system('clear')
        logo
        username = @@prompt.ask("Please enter a username")
        password = @@prompt.mask("Please enter password (0-9)")
         if username = User.find_by(username: username)
            spinner
            puts "This User already exists, please login if this is you or choose a different username"
            sleep(1)
            welcome
         else
            new_user = User.create(username: username, password: password)
            @@user = new_user
            spinner
            puts "Welcome #{username} and thanks for joining!"
            sleep(2)
            self.main_menu
         end
    end

    def main_menu
        system('clear')
        logo
        @@user.reload
        choices = ["Search for a movie to review", "Add a movie to our list", "See what movies you have rated already", "Delete Rating(s)", "See a random movie", "DELETE ALL RATINGS", "Logout"]
        selection = @@prompt.select("What would you like to do today?", choices)
        case selection
        when "Search for a movie to review"
            self.search_for_movie
        when "Add a movie to our list"
            self.create_movie
        when "See what movies you have rated already"
            self.rated_movies
        when "Delete Rating(s)"
            self.delete_rating
        when "See a random movie"
             self.random_movie
        when "DELETE ALL RATINGS"
            self.delete_all_ratings
        when "Logout"
            self.logout
        end
    end

    def search_for_movie
        system('clear')
        logo
        puts "Enter the movie you'd like to search for"
        movie_to_find = gets.chomp.capitalize
        movies = Movie.all.select{|movie|movie.title.capitalize.include?(movie_to_find)}
        if !movies.empty? && movie_to_find != ""
            spinner
            puts @@pastel.cyan("Please choose which movie you'd like to rate")
            selection = @@prompt.select("(Don't see the movie you're looking for? Add it to our list from the main menu!)", (movies.map{|movie|movie.title}), per_page: 10)
            selection = Movie.find_by_title(selection)
            if !@@user.ratings.any?{|rating| rating.movie == selection}
                puts "What is the rating for this movie? (Ratings are scaled 1-5)"
                rating = rate()
                Rating.create({user: @@user, movie: selection, rating: rating})
                puts "Your movie has been added to your list of Rated Movies"
                sleep (2)
                puts "Taking you back to the main menu.."
                main_menu
            else
                puts "You have already rated this movie"
                choice = @@prompt.select("Would you like to update your rating?", %w(Yes No))
                case choice
                when "Yes"
                    puts "What is the new rating for this movie?"
                    rating = rate()
                    Rating.all.find_by(user: @@user,movie: selection).update(rating: rating)
                    puts "The rating for this movie has been updated!"
                    sleep (2)
                    puts "Taking you back to the main menu.."
                    sleep(2)
                    main_menu
                when "No"
                    puts "Taking you back to the main menu.."
                    sleep (2)
                    main_menu
                end
            end
        else
            spinner
            puts "No movies found by that title, try again"
            sleep(2)
            self.search_for_movie
        end
    end

    def create_movie
        puts "What is the name of the movie you would like to create?"
        new_movie = gets.chomp.to_s
        puts "And what would you like to rate this movie?(1-5)"
        rating = rate()
        choice = @@prompt.select("Are you sure?", %w(Yes No Menu))
        case choice
        when "Yes"
            if !Movie.all.any?{|movie| movie.title == new_movie}
                new_movie = Movie.create(title: movie)
                Rating.create(user: @@user, movie: new_movie, rating: rating)
                spinner
                puts "Your entry has been added! Thanks for your contribution."
                puts "Taking you back to the main menu.."
                sleep (2)
                main_menu
            else Movie.all.any?{|movie| movie.title == new_movie}
                spinner
                puts "This movie already exists in our list, please use search function"
                puts "Taking you back to the main menu"
                sleep(2)
                main_menu
            end
        when "No"
            puts "Lets try that again.."
            sleep(2)
            system('clear')
            create_movie
        when "Menu"
            puts "Taking you back to the main menu.."
            spinner
            main_menu
        end
    end

    def rated_movies
        if !@@user.movies.empty?
            puts "Here are the movies you have rated already"
            spinner
            rated_movies = @@user.movies.map do |movie|
                "#{movie.title} - rated #{movie.ratings.find_by(user: @@user, movie: movie).rating}"
            end
            rated_movies << "back"
            system('clear')
            logo
            selection = @@prompt.select("Please choose which movies rating you'd like to update", (rated_movies))
            if selection == "back"
                spinner
                main_menu
            else
                selection = selection.split(" - " , 2)
                puts "What is the new rating for this movie?"
                rating = rate()
                movie = Movie.all.find_by_title(selection[0])
                Rating.all.find_by(user: @@user,movie: movie).update(rating: rating)
                spinner
                puts "The rating for this movie has been updated!"
                sleep (2)
                puts "Taking you back to the main menu.."
                sleep(2)
                main_menu
            end
        else @@user.movies.empty?
            spinner
            puts "You have not rated any movies yet."
            sleep (2)
            puts "Taking you back to the main menu.."
            sleep(2)
            main_menu
        end
    end

    def delete_rating
        if !@@user.movies.empty?
            puts @@pastel.red("Which rating(s) would you like to delete?")
            rated_movies = @@user.movies.map do |movie|
                "#{movie.title} - rated #{movie.ratings.find_by(user: @@user, movie: movie).rating}"
            end
            rated_movies << "back"
            selection = @@prompt.select("Please choose which movies rating you'd like to delete", rated_movies)
            if selection == "back"
                main_menu
            else
                selection = selection.split(" - ", 2)
                movie = Movie.find_by_title(selection[0])
                Rating.all.find_by(user: @@user, movie: movie).destroy
                spinner
                puts "This movie and its rating have been deleted from your account"
                sleep(1)
                puts "Taking you back to the main menu.."
                sleep(2)
                main_menu
            end
        else
            spinner
            puts "You haven't rated any movies yet"
            sleep (2)
            puts "Taking you back to the main menu.."
            sleep(2)
            main_menu
        end
    end

    def random_movie
        array = Movie.all.map{|movie|movie.id}
        random = rand(0...array.count)
        movie = Movie.find(array[random])
        if @@user.movies.include? movie
            self.random_movie
        else
            spinner
            puts movie.title
            selection = @@prompt.select("Would you like to rate this movie?", %w(Yes No))
            case selection
            when "Yes"
                puts "What is the rating for this movie? (Ratings are scaled 1-5)"
                rating = rate()
                Rating.create({user: @@user, movie: movie, rating: rating})
                spinner
                puts "Your movie has been added to your list of Rated Movies"
                sleep (1)
                puts "Taking you back to the main menu.."
                main_menu
            when "No"
                puts "Taking you back to the main menu.."
                sleep (1)
                main_menu
            end
        end
    end

    def delete_all_ratings
        puts @@pastel.red("THIS IS THE DANGER ZONE")
        selection = @@prompt.select("Are you sure you'd like to delete ALL ratings?", %w(Yes No))
            if selection == "Yes"
                choice = @@prompt.select("Are you DEFINITELY SURE?", %w(Yes No))
                if choice == "Yes"
                    @@user.ratings.destroy_all
                    spinner
                    puts "All ratings have been deleted."
                    puts "Taking you back to the main menu to create some more!"
                    sleep(2)
                    main_menu
                else choice == "No"
                    puts "Whew, that was close!"
                    puts "Taking you back to the main menu.."
                    sleep(2)
                    main_menu
                end
            else selection == "No"
                puts "OK. Taking you back to the main menu.."
                sleep(2)
                main_menu
            end
    end

    def logout
        puts "Thanks for logging in! See you next time!"
        sleep(5)
        @@user = nil
        system('exit')
    end

    def rate()
        rating = gets.chomp.to_i
        while(rating < 1 || rating > 5) do
            puts "Invalid choice, please enter a number 1-5"
            rating = gets.chomp.to_i
        end
        return rating
    end

    def spinner
        @@spinner.auto_spin
        sleep(2)
        @@spinner.stop("Done!")
    end

end