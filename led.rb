#!/usr/bin/ruby

################################################################################
##                         #####################################################
## TODO move to gpio gem   #####################################################
##                         #####################################################
################################################################################

Pin = Struct.new(:name, :direction, :number)
def create_pin(name_symbol, direction_number)

  direction = :out
  if direction_number <  0
    direction = :in
  end

  number = direction_number.abs

  name = name_symbol.to_s

  Pin.new(name, direction, number)

end



class Gpio

  def initialize(pins)
    @pins = pins.to_a.map { |n, d| create_pin(n, d) }

    @pins.each do |pin|

      case pin.direction

      when :in
        self.class.send(:define_method, "#{pin.name}?") do
          pin_read(pin.number)
        end

      when :out
        self.class.send(:define_method, pin.name) do |on_off|
          case on_off
          when:on, true
            puts "Pin #{pin.name} on"
            pin_on(pin.number)
          when:off, false
            puts "Pin #{pin.name} off"
            pin_off(pin.number)
          end
        end

      end

    end
  end

  def run(&block)
    begin
      activate_pins
      instance_eval(&block)
    ensure
      deactivate_pins
    end
  end

private

  def activate_pins

    @pins.map do |p| Thread.new(p) do |pin|
      puts "activating pin #{pin.number} in direction #{pin.direction} as \"#{pin.name}\""
      case pin.direction
      when :out then pin_export_out pin.number
      when :in then pin_export_in pin.number
      end
    end end.each { |t| t.join }

  end

  def deactivate_pins
    @pins.map do |p| Thread.new(p) do |pin|
      puts "deactivating pin #{pin.number}"
      pin_unexport(pin.number)
    end end.each { |t| t.join }
  end

  # TODO cleanup everything below  this comment

  def pin_export_out(i)
    puts "Now exporting LED #{i}"
    `echo "#{i}" > /sys/class/gpio/export`
    sleep 0.1
    puts "Now setting LED #{i} direction to out"
    `echo "out" > /sys/class/gpio/gpio#{i}/direction`
    sleep 0.1
  end

  def pin_export_in(i)
    puts "Now exporting LED #{i}"
    `echo "#{i}" > /sys/class/gpio/export`
    sleep 0.1
    `echo "in" > /sys/class/gpio/gpio#{i}/direction`
    sleep 0.1
  end


  def pin_unexport(i)
    puts "Unexporting LED #{i}"
    `echo "#{i}" > /sys/class/gpio/unexport`
    sleep 0.1
  end

  def pin(i, onoff)
    if(onoff)
      pin_on(i)
    else
      pin_off(i)
    end
  end
    

  def pin_on(i)
    `echo "1" > /sys/class/gpio/gpio#{i}/value`
  end

  def pin_off(i)
    `echo "0" > /sys/class/gpio/gpio#{i}/value`
  end

  def pin_read(i)
    read = `cat /sys/class/gpio/gpio#{i}/value`.chop == "1"
    # puts "[#{read}]"
    read
  end
end

def gpio(pins, &block)
  Gpio.new(pins).run(&block)
end


## Garbage schedule begins here

gpio(

  sun:      +19,
  rain:     +13,

  paper:     +6,
  recycling: +5

) do


  def days(i)
    i * 60 * 60 * 24
  end

  def take_out_paper?
    paper_dates = [
      Time.new(2017, 8,23),
      Time.new(2017, 9, 6),
      Time.new(2017, 9,20), 
      Time.new(2017,10, 5), 
      Time.new(2017,10,18), 
      Time.new(2017,11, 2), 
      Time.new(2017,11,15), 
      Time.new(2017,11,29), 
      Time.new(2017,12,13), 
      Time.new(2017,12,28) 
    ].reverse

    now = Time.now
    max_delay = days(6)
    last_date = paper_dates.find { |t| t < now }
    now.to_i - last_date.to_i < max_delay
  end

  def take_out_recycling?
    recycling_dates = [
      Time.new(2017, 8,25),
      Time.new(2017, 9,22),
      Time.new(2017,10,20), 
      Time.new(2017,11,17), 
      Time.new(2017,12,15) 
    ].reverse

    now = Time.now
    max_delay = days(14)
    last_date = recycling_dates.find { |t| t < now }
    now.to_i - last_date.to_i < max_delay
  end

# other leds, currently not active

  def sunny
    sun:on
    rain:off
  end

  def rain_today
    sun:off
    rain:on
  end

  def rain_soon
    sun:off
    rain:on
  end

  def on_off
    [:on, :off].sample
  end


  def display_time
    loop do
    t = (Time.now.hour + 4) % 12
    t = 12 if t == 0
    recycling( t & 1 != 0)
    paper(t & 2 != 0)
    rain(t & 4 != 0)
    sun(t & 8 != 0)
    sleep 30
    end
  end

  delay = 0.05

  def display_garbage
      paper take_out_paper?
      recycling take_out_recycling?
      sleep 60
  end

  def display_animation
    delay = 0.05
      sun:on
      sleep delay
      rain:on
      sleep delay
      paper:on
      sleep delay
      recycling:on
      sleep delay
      sun:off
      sleep delay
      rain:off
      sleep delay
      paper:off
      sleep delay
      recycling:off
      sleep delay
  end
    

  def display_random
      sun on_off
      rain on_off
      paper on_off
      recycling on_off
      sleep 0.25
  end

  loop do
    display_time
    sleep 30
  end

  loop do
    20.times { display_random }
  #  1.times { display_garbage }
    20.times { display_animation }
    1.times { display_time }
  end
    

end

=begin
  
def setcolor(col)

  color = {
    red:   [true,  false,  false],
    green:  [false,  true,  false],
    blue:  [false,  false,  true],
    cyan:  [false,  true,  true],
    magenta:[true,  false,  true],
    yellow:  [true,  true,  false], # but not really :(
    black:  [false,  false,  false],
    white:  [true,  true,  true]
  }

  r, g, b = color[col]
  pin(LRED, r)
  pin(LGREEN, g)
  pin(LBLUE, b)
end

sleeptime = 0.05

begin
  pin_export_out(LRED)
  pin_export_out(LGREEN)
  pin_export_out(LBLUE)
  
  brightness = [:red, :blue, :magenta, :green, :yellow, :cyan, :white]

  sequence = [6] #0, 1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1]
  
  loop do
    sequence.each { |b|
      setcolor brightness[b]
      sleep sleeptime
    }
  end
  
  loop do
    setcolor:red
    sleep sleeptime
    setcolor:green
    sleep sleeptime
    setcolor:blue
    sleep sleeptime
  end
  


ensure
  pin_off(LRED)
  pin_off(LGREEN)
  pin_off(LBLUE)

  pin_unexport(LRED)
  pin_unexport(LGREEN)
  pin_unexport(LBLUE)
end

=end
