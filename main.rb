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
#require_relative 'weather'


uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/135.xml")
response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

city_name = doc.root.elements['REPORT/TOWN'].attributes['sname']

forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

#forecast_nodes.each do |node|
 #Forecast.from_xml(node)
#end

TOKEN = "5275892175:AAHR22gLPKIDKne8Lm6ML_kuE_k7FB8R1cI"


Telegram::Bot::Client.run(TOKEN) do |bot|

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      # Here you can handle your callbacks from inline buttons
      
      if message.data == 'Moscow'
      bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      elsif message.data == 'Rostov'
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      elsif message.data == 'Samara'
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      elsif message.data == 'Peterburg'
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      elsif message.data == 'Steel'
        bot.api.send_message(chat_id: message.from.id, text: "#{city_name.uri_decode}")
        forecast_nodes.each do |node|
        bot.api.send_message(chat_id: message.from.id, text: "#{Forecast.from_xml(node)}")
        end
      end
    when Telegram::Bot::Types::Message
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Москва', callback_data: 'Moscow'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Ростов-на-Дону', callback_data: 'Rostov'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Самара', callback_data: 'Samara'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Санкт-Петербург', callback_data: 'Peterburg'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Электросталь', callback_data: 'Steel'),
      ]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot.api.send_message(chat_id: message.chat.id, text: "Здравствуй, #{message.from.first_name}, погода в каком городе тебя интерисует?", reply_markup: markup)
    end
  end
end