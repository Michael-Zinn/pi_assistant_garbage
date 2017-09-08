#!/usr/bin/ruby

require_relative 'easygpio.rb'

gpio(
  sun:       +11,
  rain:       +8,
  paper:      +9,
  recycling: +25
) do 
  loop do
    t = Time.now.hour % 12
    t = 12 if t == 0

    recycling(t & 1 != 0)
    paper    (t & 2 != 0)
    rain     (t & 4 != 0)
    sun      (t & 8 != 0)
    sleep 30
  end
end
