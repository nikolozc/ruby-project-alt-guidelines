require_relative '../config/environment'
require 'pry'
require 'tty-prompt'

#puts "hello world"
cli = CLI.new
cli.welcome

#client = Omdb::Api::Client.new(api_key: [7ec462bb])
