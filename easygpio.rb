#!/usr/bin/ruby

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
            # puts "Pin #{pin.name} on"
            pin_on(pin.number)
          when:off, false
            # puts "Pin #{pin.name} off"
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
