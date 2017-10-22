#!/usr/bin/env ruby

require 'date'
require 'yaml'

GARBAGE = YAML.load_file "garbage.yaml"

def capacity_left? date, garbage
  most_recent_disposal = garbage["schedule"].reverse.find { |t| t < date }
  garbage_full_date    = most_recent_disposal + garbage["capacity"]

  date < garbage_full_date
end
