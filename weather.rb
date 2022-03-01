

require 'rexml/document'
require 'uri'
require 'net/http'
require 'uri-handler'
require 'json'
require 'debug'
require_relative 'Forecast'

#file = File.read('cities.json', encoding: "UTF-8")
#city_names = JSON.parse(file)

#puts "У нас в базе есть #{city_names.keys.size} городов:"
#puts city_names.keys

#puts 'Погоду для какого города Вы хотите узнать?'
#city_index = STDIN.gets.chomp
#binding.break

#if city_names.has_key?(city_index)
#city = city_names[city_index]
#binding.break
uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/135.xml")
#else 
#abort 'Извините, этот город ещё не добавлен в нашу базу данных' 
#end

response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']

forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

forecast_nodes.each do |node|
puts city_name.uri_decode
a = Forecast.from_xml(node)
binding.break
return a
end
end
binding.break
puts a
