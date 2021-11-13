require 'nokogiri'
require 'open-uri'
require 'json'

url = "https://www.foodnetwork.com/restaurants/shows/diners-drive-ins-and-dives/a-z/p/"

test_url = url + "1"



index = 1
restaurants = []
while index < 86
    @doc = Nokogiri::HTML(URI.open("#{url}#{index}"))
    @doc.css('.l-List > .m-MediaBlock').each do | elem |
        diner = {}
        diner[:title] = elem.css('h3').inner_text.strip
        diner[:address] = elem.css('.m-MediaBlock__m-Info').inner_text.strip
        diner[:description] = elem.css('.m-MediaBlock__a-Description').inner_text.strip
        restaurants << diner if diner[:title].length > 0
    end
    puts "On #{index}: Found #{restaurants.count}"
    index += 1
    sleep 0.5
end

File.open("ddd.json", "w") do |f|
    f.write(restaurants.to_json)
end