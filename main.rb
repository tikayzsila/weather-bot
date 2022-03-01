if Gem.win_platform?
    Encoding.default_external = Encoding.find(Encoding.locale_charmap)
    Encoding.default_internal = __ENCODING__
  
    [STDIN, STDOUT].each do |io|
      io.set_encoding(Encoding.default_external, Encoding.default_internal)
    end
end

require 'telegram/bot'
require 'uri-handler'
require 'rexml/document'
require 'uri'
require 'net/http'
require 'json'
require 'debug'
require_relative 'Forecast'

file = File.read('cities.json', encoding: "UTF-8")
city_names = JSON.parse(file)

TOKEN = "5275892175:AAHR22gLPKIDKne8Lm6ML_kuE_k7FB8R1cI"


Telegram::Bot::Client.run(TOKEN) do |bot|

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery

      
      if message.data == 'Москва'
        city = city_names['Москва']
#add new method for parse
        uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city["id"]}.xml")
        response = Net::HTTP.get_response(uri)
        doc = REXML::Document.new(response.body)
        city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']
        forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a
#add new method for parse
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
          forecast_nodes.each do |node|
          bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
          end

      elsif message.data == 'Ростов-на-Дону'
        city = city_names['Ростов-на-Дону']
#add new method for parse
        uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city["id"]}.xml")
        response = Net::HTTP.get_response(uri)
        doc = REXML::Document.new(response.body)
        city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']
        forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a
#add new method for parse
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      elsif message.data == 'Самара'
#add new method for parse
        city = city_names['Самара']
        uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city["id"]}.xml")
        response = Net::HTTP.get_response(uri)
        doc = REXML::Document.new(response.body)
        city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']
        forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a
#add new method for parse
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      elsif message.data == 'Санкт-Петербург'
        city = city_names['Санкт-Петербург']
#add new method for parse
        uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city["id"]}.xml")
        response = Net::HTTP.get_response(uri)
        doc = REXML::Document.new(response.body)
        city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']
        forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a
#add new method for parse
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      elsif message.data == 'Электросталь'
        city = city_names['Электросталь']
#add new method for parse
        uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city["id"]}.xml")
        response = Net::HTTP.get_response(uri)
        doc = REXML::Document.new(response.body)       
        city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']
        forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a
#add new method for parse
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      end
    when Telegram::Bot::Types::Message
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Москва', callback_data: 'Москва'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Ростов-на-Дону', callback_data: 'Ростов-на-Дону'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Самара', callback_data: 'Самара'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Санкт-Петербург', callback_data: 'Санкт-Петербург'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Электросталь', callback_data: 'Электросталь'),
      ]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot.api.send_message(chat_id: message.chat.id, text: "Здравствуй, #{message.from.first_name}, погода в каком городе тебя интерисует?", reply_markup: markup)
    end
  end
end