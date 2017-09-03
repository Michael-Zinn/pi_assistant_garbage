#!/usr/bin/ruby

# You need to pass your API key as the first parameter

require_relative 'easygpio.rb'
require 'net/http'
require 'json'

API_KEY = ARGV[0]
CITY_CODE = ARGV[1]
FORECAST = URI("https://api.openweathermap.org/data/2.5/forecast?id=#{CITY_CODE}&APPID=#{API_KEY}")

gpio(
#  sun:   +19, # yellow sun LED
#  water: +13  # blue water drop LED
  top: 5,
  right: 16,
  bottom: 20,
  left: 21
) do

  top:on
  right:on
  bottom:on
  left:on
  sleep 60

=begin
  delay = 0.5
  loop do
    top:on
    sleep delay
    right:on
    top:off
    sleep delay
    bottom:on
    right:off
    sleep delay
    left:on
    bottom:off
    sleep delay
    left:off
  end
=end

  loop do
    response = JSON.parse(Net::HTTP.get(FORECAST))
    weather = response["list"].map { |w| w["weather"][0]["main"] }

    clock = weather.take(4).map{ |w| w == "Rain" }.rotate((Time.now.hour - 2) / -3)

    top clock[0]
    right clock[1]
    bottom clock[2]
    left clock[3]

    sleep 10 * 60
  end
    
=begin

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
=end

end
