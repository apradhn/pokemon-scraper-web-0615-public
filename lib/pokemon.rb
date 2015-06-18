require_relative "../bin/sql_runner.rb"

class Pokemon
  attr_accessor :name, :type, :hp
  @@all = []

  def initialize
    @hp = 60
  end

  def self.save(name, type, db)
    sql = <<-SQL 
      INSERT INTO pokemon(name, type) VALUES
      (?, ?);
    SQL
    db.execute(sql, name, type)
  end

  def self.find(id, db)
    @@db = db

    sql = <<-SQL
      SELECT name, type FROM pokemon WHERE id = ?
    SQL

    data = db.execute(sql, id).flatten
    Pokemon.new.tap do |p|
      p.name = data[0]
      p.type = data[1]
    end
  end

  def alter_hp(amount)
    sql = <<-SQL
      UPDATE pokemon SET hp = ? WHERE name = ?
    SQL
    Pokemon.db.execute(sql, amount, self.name)
  end

  def self.all
    @@all
  end

  def self.db
    @@db
  end


end