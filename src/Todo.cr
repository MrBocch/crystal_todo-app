require "./repo.cr"
require "tallboy"

# TODO: Write documentation for `Todo`
module Todo
  VERSION = "0.1.0"

  rows = Repo.select_evr_task()
  table = Tallboy.table do
    header do
      cell "What?", align: :center
      cell "When?"
    end

    rows.each do |t|
      row [t.title, t.due_date]
    end
  end

  puts "CLI-TODO"
  puts table

  loop do
    puts ""
    puts "(1) New task"
    puts "(2) Completed task"
    puts "(.q) Quit"
    print "> "
    c = gets() || ""

    case c
    when "1"
    when "2"
    when ".q", "quit", "exit"
      break
    else
      puts "Dont recognize #{c}"
    end
  end

  def insert_task
    get_date_time
  end

  def get_date_time
    puts "Year?"
    puts "Month?"
    puts "Day?"

    puts "Hour?"
    puts "Minute?"
  end
end
