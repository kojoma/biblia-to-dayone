require "csv"
require "optparse"
require "time"

EXPORT_FILE_PREFIX = "files/dayone-plain-text-"
EXPORT_ENTRY_SIGNATURE = "\n====\nImport from Biblia app.\n"

def options
  opt = OptionParser.new
  parsed = {}

  opt.on("--biblia=VAL", "Please specify the csv file path of Biblia app") {|v| v }
  opt.parse!(ARGV, into: parsed)

  parsed
end

def export_file_name
  "#{EXPORT_FILE_PREFIX}#{Time.now.nsec}.txt"
end

class DayoneFormatter
  DAYONE_DATE_FORMAT = "%B %d, %Y 0:00:00 JST"

  def initialize(csv_row)
    @csv_row = csv_row
  end

  def entry_title
    @csv_row[0]
  end

  def entry_date
    Date.parse(@csv_row[6]).strftime(DAYONE_DATE_FORMAT)
  end

  def entry_body
    @csv_row[8]
  end

  def should_create_entry?
    @csv_row[12] != "1"
  end
end

count = 0
File.open(export_file_name, "w") do |f|
  csv_path = options[:biblia]
  CSV.foreach(csv_path) do |row|
    formatter = DayoneFormatter.new(row)
    next unless formatter.should_create_entry?

    f.puts("\tDate: #{formatter.entry_date}")
    f.puts("")
    f.puts("# #{formatter.entry_title}")
    f.puts("")
    f.puts("#{formatter.entry_body}")
    f.puts(EXPORT_ENTRY_SIGNATURE)
    f.puts("")

    count += 1
  end
end

puts "Successfully export #{export_file_name}, entry count: #{count}"
