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
    {title: "The Goonies", release_date: "June 7th, 1985"},
    {title: "Spellbound", release_date: "December 13th, 2018"},
    {title: "Sherlock Holmes", release_date: "December 25th, 2009"},
    {title: "Alice In Wonderland", release_date: "August 13th, 2015"},
    {title: "Toy Story 3", release_date: "November 22nd, 2015"},
    {title: "Moana", release_date: "November 23rd, 2016"},
    {title: "Frozen", release_date: "November 27th, 2013"},
    {title: "Back to the Future", release_date: "July 3rd, 1985"},
    {title: "Back to the Future: Part II", release_date: "November 22nd, 1989"},
    {title: "Frozen 2", release_date: "November 22nd, 2019"},

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
