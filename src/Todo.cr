require "./repo.cr"
require "tallboy"
require "time"

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
      insert_task
    when "2"
    when ".q", "quit", "exit", "q"
      break
    else
      puts "Dont recognize #{c}"
    end
  end


end


def insert_task
  puts "What is it?"
  title = gets() || ""
  d = get_date_time
  Repo.insert_task(title, d)
end

def get_date_time
  tyear = Time.local.to_s("%Y")
  puts "Year (#{tyear})?"
  y = now_or_later(gets(), tyear)

  tmonth = Time.local.to_s("%m")
  puts "Month (#{tmonth})?"
  m = now_or_later(gets(), tmonth)

  tday = Time.local.to_s("%d")
  puts "Day (#{tday})?"
  d = now_or_later(gets(), tday)

  puts "Hour?"
  hour = gets() || ""
  puts "Minute?"
  min = gets() || ""
  # make sure to follow correct format, so sqlite can sort it
  # return "#{d}-#{m}-#{y} | #{hour}:#{min}"
end

def now_or_later(time : (String | Nil), predetermined : String) : String
  time = time || ""
  time != "" ? time : predetermined
end

struct Table_Time
  property year, month, day, hour, minute
  def initialize(@year   : String,
                 @month  : String,
                 @day    : String,
                 @hour   : String,
                 @minute : String)
  end
end
