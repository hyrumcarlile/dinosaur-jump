require_relative 'classes/game_object.rb'
LOGGER = false

def tick(args)
  puts "-------------------- START TICK \##{Kernel.tick_count}--------------------------" if LOGGER
  puts "Creating Game Object" if LOGGER
  args.state.game_object ||= GameObject.new(args)

  puts "Calling Game Object" if LOGGER
  args.state.game_object.call

  puts "Setting Output Args" if LOGGER
  args = args.state.game_object.args
  puts "Total Objects: #{args.state.objects.length + args.state.environment_objects.length}" if LOGGER
  puts "----------------- END TICK \##{Kernel.tick_count}-------------------------------" if LOGGER
end
