if Gem.win_platform?
    Encoding.default_external = Encoding.find(Encoding.locale_charmap)
    Encoding.default_internal = __ENCODING__
  
    [STDIN, STDOUT].each do |io|
      io.set_encoding(Encoding.default_external, Encoding.default_internal)
    end
end

require 'telegram/bot'
#require_relative 'weather'



TOKEN = "5275892175:AAHR22gLPKIDKne8Lm6ML_kuE_k7FB8R1cI"


Telegram::Bot::Client.run(TOKEN) do |bot|

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      # Here you can handle your callbacks from inline buttons
      if message.data == 'Moscow'
        bot.api.send_message(chat_id: message.from.id, text: "HUETA")
      elsif
        message.data == 'Rostov'
        bot.api.send_message(chat_id: message.from.id, text: "HUETA")
      elsif
        message.data == 'Samara'
        bot.api.send_message(chat_id: message.from.id, text: "HUETA")
      elsif
        message.data == 'Peterburg'
        bot.api.send_message(chat_id: message.from.id, text: "HUETA")
      elsif
        message.data == 'Steel'
        bot.api.send_message(chat_id: message.from.id, text: "HUETA")
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