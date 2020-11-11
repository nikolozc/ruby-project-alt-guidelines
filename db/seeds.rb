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
    {title: "Legally Blonde", release_date: "July 13th, 2001"},
    {title: "Nightcrawler", release_date: "October 31st, 2014"},
    {title: "Snowpiercer", release_date: "July 29th, 2013"},
    {title: "Deadpool", release_date: ""},
    {title: "10 Things I Hate About You", release_date: "March 31st, 1999"},
    {title: "Oblivion", release_date: "April 19th, 2013"},
    {title: "13 Going on 30", release_date: "April 23rd, 2004"},
    {title: "Disclosure", release_date: "January 27th, 2020"},
    {title: "The Rocky Horror Picture Show", release_date: "September 25th, 1975"},
    {title: "Flower", release_date: "March 16th, 2018"},
    {title: "Hairspray", release_date: "July 20th, 2007"},
    {title: "Hulk", release_date: "June 17th, 2003"},
    {title: "Mean Girls", release_date: "April 30th, 2004"},
    {title: "Chappie", release_date: "March 6th, 2015"},
    {title: "Rent", release_date: "November 23rd, 2005"},
    {title: "SpiderMan", release_date: "May 4th, 2007"},
    {title: "The Devil Wears Prada", release_date: "June 30th, 2006"},
    {title: "The Ritual", release_date: "October 13th, 2017"},
    {title: "Lolita", release_date: "June 13th, 1962"},
    {title: "Clueless", release_date: "July 19th, 1995"},
    {title: "Divergent", release_date: "March 21st, 2014"},
    {title: "Pitch Perfect", release_date: "September 28th, 2012"},
    {title: "The Game", release_date: "September 12th, 1997"},
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
