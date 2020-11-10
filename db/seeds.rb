require 'pry'
require 'rest-client' # in order to make HTTP requests from a ruby file
require 'json'

Movie.destroy_all
User.destroy_all
Rating.destroy_all

m1 = Movie.create(title: "Transformers", release_date: "July 3rd, 2007"),
m2 = Movie.create(title: "Sex and The City: The Movie", release_date: "May 27, 2008"),
m3 = Movie.create(title: "Holes", release_date: "April 11, 2003")

u1 = User.create(username: "Connor", password: 000)
u2 = User.create(username: "Nikoloz", password: 000)

Rating.create(
    {},
    {},
    {}
)