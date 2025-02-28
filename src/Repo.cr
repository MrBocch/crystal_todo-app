require "db"
require "sqlite3"
require "time"

module Repo
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

Repo.connect()
Repo.insert_task("DispMov Lab #1", "2025-04-10 02:05:40")
Repo.insert_task("DispMov Lab #1", "2025-04-10 01:00:00")
Repo.insert_task("DispMov Lab #2", "2025-10-10 02:05:40")
Repo.insert_task("DispMov Lab #3", "2026-04-10 02:05:40")
