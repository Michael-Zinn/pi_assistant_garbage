#!/usr/bin/ruby

# You need to pass your API key as the first parameter

require_relative 'easygpio.rb'
require 'net/http'
require 'json'

API_KEY = ARGV[0]
CITY_CODE = ARGV[1]
FORECAST = URI("https://api.openweathermap.org/data/2.5/forecast?id=#{CITY_CODE}&APPID=#{API_KEY}")

gpio(
  sun:   +19, # yellow sun LED
  water: +13  # blue water drop LED
) do

  loop do
    response = JSON.parse(Net::HTTP.get(FORECAST))
    weather = response["list"].map { |w| w["weather"][0]["main"] }

    if weather[0] == "Rain"
      sun:off
      water:on
    elsif weather.take(5).include?("Rain")
      sun:on
      water:on
    else
      sun:on
      water:off
    end
    sleep 10 * 60
  end

end
