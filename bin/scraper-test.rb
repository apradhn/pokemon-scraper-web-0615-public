require_relative "environment.rb"
require_relative "run.rb"

db = SQLite3::Database.new('db/pokemon.db')
scraper = Scraper.new(db)
scraper.scrape