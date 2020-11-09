require_relative '../config/environment'

puts "hello world"

client = Omdb::Api::Client.new(api_key: [7ec462bb])
