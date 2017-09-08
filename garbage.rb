#!/usr/bin/env ruby

require 'date'
require 'yaml'

require_relative 'easygpio.rb'

GARBAGE = YAML.load File.open("garbage.yaml", "rb").read

gpio(
  paper:     +26,
  recycling: +19
) do

  def capacity_left? date, garbage
    most_recent_disposal = garbage["schedule"].reverse.find { |t| t < date }
    garbage_full_date    = most_recent_disposal + garbage["capacity"]

    date < garbage_full_date
  end

  loop do
    paper     (capacity_left? Date.today, GARBAGE["paper"    ])
    recycling (capacity_left? Date.today, GARBAGE["recycling"])
    sleep 60
  end

end
