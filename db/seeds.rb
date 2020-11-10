require 'pry'
require 'rest-client' # in order to make HTTP requests from a ruby file
require 'json'

Movie.destroy_all
User.destroy_all
Rating.destroy_all

Movie.create([
    {title: "Transformers", release_date: "July 3rd, 2007"},
    {title: "Transformers: Revenge of the Fallen", release_date: "July 3rd, 2009"},
    {title: "Transformers: Dark of the Moon", release_date: "July 3rd, 2011"},
    {title: "Trans", release_date: "October 3rd, 2012"},
    {title: "Sex and The City: The Movie", release_date: "May 27, 2008"}
])


m1 = Movie.first
m2 = Movie.second

User.create([
    {username: "Connor", password: 000},
    {username: "Nikoloz", password: 000}
])

u1 = User.first
u2 = User.second

Rating.create([
    {user: u1, movie: m1, rating: 4},
    {user: u2, movie: m2, rating: 5}
])
