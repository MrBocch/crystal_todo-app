require "db"
require "sqlite3"
require "time"

struct Task
  property taskID, title, due_date, completed, completion_date, groupID
  def intialiaze(@taskID : Int64,
                @title : String,
                @due_date : String,
                @completed : Bool,
                @completion_date : (String | Nil),
                @groupID : Int64)
  end
end

enum GroupID
  DUE
  COMPLETED
  FAILED
end

module Repo
  # this probably wont work
  DB_PATH = "./test.db"

  def self.connect()
    if !File.exists?(DB_PATH)
      init_db(DB_PATH)
    end
  end

  def self.insert_task(title : String, due_date : String)
    DB.open("sqlite3://#{DB_PATH}") do |db|
      db.exec <<-SQL, title, due_date, 1
        INSERT INTO Task (Title, DueDate, GroupID)
        VALUES (?, ?, ?)
      SQL
    end
  end

  def self.complete_task(id : Int64, completion_date : String) : Nil
    DB.open("sqlite3://#{DB_PATH}") do |db|
      db.exec <<-SQL, true, completion_date, 2, id
        UPDATE Task
        SET Completed      = ?,
            CompletionDate = ?,
            GroupID        = ?
        WHERE TaskID       = ?
      SQL
    end
  end

  def self.select_evr_task() : Array(Task)
    rows = [] of Task
    DB.open("sqlite3://#{DB_PATH}") do |db|
      # so i made a struct for the query result, have an array of these
      # rs is a: SQLite3::ResultSet, am i dumb, i cant find any documentation
      # chatgpt: "rs values must be read sequentially"
      # very interesting, if you dont access everything sequantially its an error
      db.query "SELECT * FROM Task WHERE GroupID = 1 ORDER BY DueDate" do |rs|
            rs.each do
              row = Task.new()
              # first Taskid
              row.taskID = rs.read(Int64)
              # title
              row.title = rs.read(String)
              # date
              row.due_date = rs.read(String)
              # completed bool
              row.completed = rs.read(Bool)
              # completion date can be nil?
              row.completion_date = rs.read(String | Nil)
              # groupID
              row.groupID = rs.read(Int64)
              rows.push row
            end
          end
    end
    return rows
  end

  private def self.init_db(path : String) : Nil
    DB.open("sqlite3://#{DB_PATH}") do |db|
      db.exec <<-SQL
        CREATE TABLE IF NOT EXISTS Task(
              TaskID INTEGER PRIMARY KEY AUTOINCREMENT,
              Title TEXT NOT NULL,
              DueDate DATETIME NOT NULL,
              Completed BOOLEAN DEFAULT FALSE,
              CompletionDate DATETIME,
              GroupID INTEGER,
              FOREIGN KEY (GroupID) REFERENCES Groups(GroupID)
            );
        SQL

      db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS Groups(
          GroupID INTEGER PRIMARY KEY,
          GroupName TEXT NOT NULL
        );
      SQL

      db.exec <<-SQL
      INSERT INTO Groups (GroupID, GroupName)
        VALUES (1, 'Due'), (2, 'Completed'), (3, 'Failed');
      SQL
    end
  end
end
