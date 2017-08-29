#!/usr/bin/ruby

require_relative 'easygpio.rb'

gpio(
  sun:  +19,
  rain: +13
) do

  def sunny
    sun:on
    rain:off
  end

  def rain_today
    sun:off
    rain:on
  end

  def rain_soon
    # TODO make the LED blink
    sun:off
    rain:on
  end

  sun:on
  rain:on

  sleep 10000

end
