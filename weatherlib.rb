#!/usr/bin/ruby

# You need to pass your API key as the first parameter

require 'net/http'
require 'json'
require 'yaml'

CONFIG = YAML.load_file 'weatherlib.yaml'

API_KEY = CONFIG["api_key"] # ARGV[0]
CITY_CODE = CONFIG["city_code"] # ARGV[1]
FORECAST = URI("https://api.openweathermap.org/data/2.5/forecast?id=#{CITY_CODE}&APPID=#{API_KEY}")

def get_weather
  response = JSON.parse(Net::HTTP.get(FORECAST))
  weather = response["list"].map { |w| w["weather"][0]["main"] }

  weather.take(4).map{ |w| w == "Rain" }
end

