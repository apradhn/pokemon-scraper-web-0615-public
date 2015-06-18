require 'nokogiri'
require 'open-uri'
require_relative './pokemon.rb'
require_relative '../bin/sql_runner.rb'

class Scraper
  attr_reader :db

  def initialize(db)
    @db = db
  end

  def scrape
    html = File.open("./pokemon_index.html")
    doc = Nokogiri::HTML(html)
    name_elements = doc.css("a.ent-name")
    type_elements = doc.css(".aside a.itype:first-child")
    pokemon = []
    name_elements.each_with_index do |name_elem, i|
      pokemon << Pokemon.new.tap do |p| 
        p.name = name_elem.text
        p.type = type_elements[i].text
      end
    end
    insert_pokemon(pokemon)
  end

  def insert_pokemon(pokemon)
    pokemon.each do |p|
      name = p.name
      type = p.type
      sql = <<-SQL
        INSERT INTO pokemon(name, type) VALUES(?, ?);
      SQL
      db.execute(sql, name, type)
    end
  end
end