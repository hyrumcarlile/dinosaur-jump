require_relative 'classes/game_object.rb'
def tick(args)
  puts "-------------------- START TICK \##{Kernel.tick_count}--------------------------"
  game_object = GameObject.new(args)
  game_object.call
  args = GameObject.output_args
  # manually dereference the instance so garbage collector
  # will clear it from memory
  game_object = nil
  puts "----------------- END TICK \##{Kernel.tick_count}-------------------------------"
end
