require_relative 'scenes/game_scene.rb'
require_relative 'scenes/menu_scene.rb'
require_relative 'scenes/pause_menu_scene.rb'
require_relative 'classes/services/text_renderer.rb'
require_relative 'tests/tests.rb'

LOGGER = true
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

  args.state.scene ||= MenuScene.new(args)

  puts "Calling Scene Tick" if LOGGER
  args.state.scene.tick

  puts "----------------- END TICK \##{Kernel.tick_count}-------------------------------" if LOGGER
end

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
end
