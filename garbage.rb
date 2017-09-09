#!/usr/bin/env ruby

require 'date'
require 'yaml'
require_relative 'easygpio.rb'

GARBAGE = YAML.load File.read("garbage.yaml")

def capacity_left? date, garbage
  most_recent_disposal = garbage["schedule"].reverse.find { |t| t < date }
  garbage_full_date    = most_recent_disposal + garbage["capacity"]

  date < garbage_full_date
end

gpio(
  led_paper:     +26,
  led_recycling: +19
) do

  loop do
    led_paper     (capacity_left? Date.today, GARBAGE["paper"    ])
    led_recycling (capacity_left? Date.today, GARBAGE["recycling"])
    sleep 60
  end

end
