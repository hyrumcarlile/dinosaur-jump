require_relative 'classes/game_object.rb'
def tick(args)
  args.state.objects ||= []
  args.state.game_duration ||= 0
  args.state.player ||= Player.new

  game_object = GameObject.new(args)

  game_object.call

  args = game_object.output_args
end
