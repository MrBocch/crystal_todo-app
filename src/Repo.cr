require "db"
require "sqlite3"
require "time"

class Repo
  #def initialize()
  #end
  def self.connect()
    db_path = "./test.db"
    if !File.exists?(db_path)
      init_db(db_path)
    end
  end

  private def self.init_db(path : String) : Nil
    DB.open("sqlite3://#{path}") do |db|
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
