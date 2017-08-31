#!/usr/bin/ruby

require_relative 'easygpio.rb'

# morses random characters

gpio(
  buzzer: +4
) do 
  loop do
    buzzer:on
    sleep 0.1
    if [true, false].sample
      sleep 0.2
    end
    buzzer:off
    sleep 0.1
    if [true, false].sample
      sleep 0.2
    end
  end
end
