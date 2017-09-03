#!/usr/bin/env ruby

require_relative 'easygpio'

gpio(

  led_white: +26,
  led_green: +19,
  buzzer:    +12,

  btn_left:  -13,
  btn_right:  -6

) do

  led_white:on
  led_green:on

  loop do
    if btn_left?
      buzzer:on
    else
      buzzer:off
    end
  end

  loop do
    led_white btn_left?
    led_green btn_right?
    sleep 0.1
  end
end
