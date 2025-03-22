require "./repo.cr"
require "tallboy"
require "time"

# TODO: Write documentation for `Todo`
module Todo
  VERSION = "0.1.0"
  puts "CLI-TODO"

  loop do
    show_table(1)
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
  print "What is it?\n>"
  title = gets() || ""
  d = get_date_time
  Repo.insert_task(title, d)
end

def get_date_time
  tyear = Time.local.to_s("%Y")
  print "Year (#{tyear})?\n> "
  y = now_or_later(gets(), tyear)

  tmonth = Time.local.to_s("%m")
  print "Month (#{tmonth})?\n> "
  m = now_or_later(gets(), tmonth)

  tday = Time.local.to_s("%d")
  print "Day (#{tday})?\n> "
  d = now_or_later(gets(), tday)

  print "Hour? (Military Time)\n>"
  hour = gets() || ""
  hour = hour.size < 2 ? "0#{hour}" : hour
  print "Minute?\n> "
  min = gets() || ""
  min = min.size < 2 ? "0#{min}" : hour
  # make sure to follow correct format, so sqlite can sort it
  # 2023-12-31 23:59:59
  return "#{y}-#{m}-#{d} #{hour}:#{min}:00"
end

def now_or_later(time : (String | Nil), predetermined : String) : String
  time = time || ""
  time != "" ? time : predetermined
end

# i was going to write some cleaver way
# of using a hashmap or a set, to set
# settings on the table, but you know what
# fackit, unsophisticated
# 1 : Title, DueWhen
# 2 : ID, Title
#
def show_table(option : Int32) : Nil
    rows = Repo.select_evr_task()
    table = Tallboy.table do
      header do
        # cell k, align: :center
        case option
        when 1
          cell "Title", align: :center
          cell "When", align: :center
        when 2
          cell "ID", align: :center
          cell "Title", align: :center
        end

      end
      rows.each do |t|
        case option
        when 1
          row [t.title, t.due_date]
        when 2
          row [t.taskID, t.title]
        end
      end
    end

  puts table
end
