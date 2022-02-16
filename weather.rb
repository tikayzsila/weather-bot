if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'rexml/document'
require 'uri'
require 'net/http'
require 'uri-handler'
require_relative 'Forecast'
CITIES = {
  37 => 'Москва',
  69 => 'Санкт-Петербург',
  99 => 'Новосибирск',
  59 => 'Пермь',
  115 => 'Орел',
  121 => 'Чита',
  9014 => 'Северодонецк',
  135 => 'Ростов-на-Дону'
}.invert.freeze
city_names = CITIES.keys

puts 'Погоду для какого города Вы хотите узнать?'
city_names.each_with_index { |name, index| puts "#{index + 1}: #{name}" }
city_index = gets.to_i
unless city_index.between?(1, city_names.size)
  city_index = gets.to_i
  puts "Введите число от 1 до #{city_names.size}"
end

city_id = CITIES[city_names[city_index - 1]]

uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city_id}.xml")
response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']

forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a


forecast_nodes.each do |node|
puts city_name.uri_decode
puts Forecast.from_xml(node)
end
