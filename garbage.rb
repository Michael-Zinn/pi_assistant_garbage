#!/usr/bin/ruby

require_relative 'easygpio.rb'

gpio(
  paper:     +6,
  recycling: +5
) do

  paper = [
    (Time.new 2017, 8,23),
    (Time.new 2017, 9, 6),
    (Time.new 2017, 9,20), 
    (Time.new 2017,10, 5), 
    (Time.new 2017,10,18), 
    (Time.new 2017,11, 2), 
    (Time.new 2017,11,15), 
    (Time.new 2017,11,29), 
    (Time.new 2017,12,13), 
    (Time.new 2017,12,28) 
  ]
  recycling = [
    (Time.new 2017, 8,25),
    (Time.new 2017, 9,22),
    (Time.new 2017,10,20), 
    (Time.new 2017,11,17), 
    (Time.new 2017,12,15) 
  ]

  def days i 
    i * 60 * 60 * 24
  end

  def take_out_trash? type, max_delay 
    now = Time.now
    last_date = type.find { |t| t < now }
    now.to_i - last_date.to_i < max_delay
  end

  loop do
      paper     (take_out_trash? paper    , (days  6))
      recycling (take_out_trash? recycling, (days 14))
      sleep 60
  end

end
