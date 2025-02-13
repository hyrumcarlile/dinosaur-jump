require_relative 'classes/game_object.rb'
LOGGER = false
LOG_PERFORMANCE = false
MAX_TIME_FOR_TICK = 0.016

def tick(args)
  if LOG_PERFORMANCE
    start_time = Time.now
    main(args)
    end_time = Time.now

    frame_performance = end_time - start_time
    output_string = "Frame performance: #{frame_performance}"

    if frame_performance < MAX_TIME_FOR_TICK
      output_string = output_string.green
    else
      output_string = output_string.red
    end

    puts output_string
  else
    main(args)
  end
end

def main(args)
  puts "-------------------- START TICK \##{Kernel.tick_count}--------------------------" if LOGGER
  puts "Creating Game Object" if LOGGER
  args.state.game_object ||= GameObject.new(args)

  puts "Calling Game Object" if LOGGER
  args.state.game_object.call

  puts "Setting Output Args" if LOGGER
  args = args.state.game_object.args
  puts "Total Objects: #{args.state.objects.length + args.state.foreground_objects.length + args.state.background_objects.length + args.state.sky_objects.length}" if LOGGER
  puts "----------------- END TICK \##{Kernel.tick_count}-------------------------------" if LOGGER
end

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
end
