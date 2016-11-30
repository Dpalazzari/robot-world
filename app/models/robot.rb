require 'sqlite3'
require 'pry'

class Robot
  attr_reader :name, :city, :state, :department, :id
  def initialize(robot_params)
    @id         = robot_params["id"] if robot_params["id"]
    @name       = robot_params["name"]
    @city       = robot_params["city"]
    @state      = robot_params["state"]
    @department = robot_params["department"]
    @database   = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
  end

  def self.database
    database   = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
  end

  def save
    @database.execute("INSERT INTO robots (name, city, state, department) VALUES (?, ?, ?, ?);", @name, @city, @state, @department)
  end

  def self.all
    database   = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    robots = database.execute("SELECT * FROM robots")
    robots.map { |robot| Robot.new(robot)}
  end

  def self.find(id)
    database   = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    robot = database.execute("SELECT * FROM robots WHERE id = ?", id).first
    Robot.new(robot)
  end

  def self.update(id, robot_params)
    database.execute("UPDATE robots
                      Set name = ?,
                        city = ?,
                        state = ?,
                        department = ?
                      WHERE id = ?;",
                      robot_params[:name],
                      robot_params[:city],
                      robot_params[:state],
                      robot_params[:department],
                      id)
    Robot.find(id)
  end

  def self.destroy(id)
    database.execute("DELETE FROM robots WHERE id = ?;", id)
  end


end
