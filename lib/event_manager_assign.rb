require 'csv'
require 'date'
require 'time'

puts 'Data cleaning initialized'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

hour_array = []

def clean_phone(num)
  num = num.scan(/\d/).join
  if num.length == 10
    num
  elsif num.length == 11 && num[0] == '1'
    num.slice!(0)
    num
  else
    false
  end
end

# gets multiple mode for the hour_array
def average_hour(array, find_all: true)
  histogram = array.inject(Hash.new(0)) { |h, n| h[n] += 1; h } 
  modes = nil
  histogram.each_pair do |item, times|
    modes << item if modes && times == modes[0] and find_all
    modes = [times, item] if (!modes && times>1) or (modes && times>modes[0]) 
  end
  modes ? modes[1...modes.size] : modes
end

contents.each do |row|
  phone = clean_phone(row[:homephone])
  if phone == false
    puts 'Bad Number'
  else
    puts phone
  end

  date = DateTime.strptime(row[:regdate], '%m/%d/%Y %H:%M')
  hour_array << date.hour
  puts average_hour(hour_array)
end
