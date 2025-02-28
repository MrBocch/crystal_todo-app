require "./repo.cr"
require "tallboy"

# TODO: Write documentation for `Todo`
module Todo
  VERSION = "0.1.0"

  # D.connect
  table = Tallboy.table do
    header do
      cell "What?", align: :center
      cell "When?"
    end

    row ["homework",       Time.utc.to_s("%d-%m-%y")]
    row ["darkolivegreen",  "#556b2f"]
    row ["papayawhip",      "#ffefd5"]
  end

  puts table.class
end
