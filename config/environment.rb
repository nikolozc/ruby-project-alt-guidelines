require 'bundler'
Bundler.require


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'app/models'
require_all 'db/migrate'

#Uncomment bottom line after done with project
ActiveRecord::Base.logger = nil
