# This is a singleton class that is in charge of coordinating all game objects
# and drawing them to the screen each frame
require_relative 'base_object'
require_relative 'background'
require_relative 'player'
require_relative 'cactus'
require_relative 'pterodactyl'

class GameObject
  def initialize(args)
    @input_args = args
    @output_args = args
    @player = args.state.player || Player.new
    @game_over = args.state.game_over || false
  end

  attr_reader :player, :input_args, :output_args
  attr_accessor :game_over

  # This is the main method that gets called every frame
  # it does all the necessary calculations and rendering
  def call
    add_new_objects
    handle_input
    handle_object_calculations
    handle_player_calculation

    handle_collisions

    render_background
    render_ui
    render_output_args
    render_player

    @output_args.state.game_duration += 1 unless @game_over
  end

  def add_new_objects
    return if @game_over

    if rand(220).zero?
      @output_args.state.objects << Cactus.new(x: Grid.w, y: 0, w: 60, h: 80, x_velocity: -7, gravity: 0)
    end

    if rand(500).zero?
      @output_args.state.objects << Pterodactyl.new(x: Grid.w, y: (rand(150) + 100), w: 80, h: 70, x_velocity: -9, gravity: 0)
    end
  end

  def handle_input
    if @game_over
      check_for_game_reset
    else
      @player.handle_input(args: @input_args)
    end
  end

  def handle_object_calculations
    return if @game_over

    @output_args.state.objects.each do |object|
      next unless object.can_move?

      object.calc
    end
  end

  def handle_player_calculation
    return if @game_over

    @player.calc
  end

  def handle_collisions
    return if @game_over
    return unless @player.check_for_collisions(objects: @output_args.state.objects.select(&:damages_player?))

    handle_game_over
  end

  def handle_game_over
    @output_args.state.game_over = true
    @output_args.state.objects.each do |object|
      object.x_velocity = 0
      object.y_velocity = 0
      object.x_acceleration = 0
      object.y_acceleration = 0
    end
  end

  def render_ui
    @output_args.outputs.labels << { x: Grid.w - 150, y: Grid.h - 20, text: "Score: #{(@input_args.state.game_duration / 5).to_i}" }
  end

  def render_background
    @output_args.outputs.sprites << Background.new.to_sprite
  end

  def render_output_args
    @output_args.state.objects.each do |object|
      @output_args.outputs.sprites << object.to_sprite
    end
  end

  def render_player
    @output_args.outputs.sprites << @player.to_sprite
  end

  def check_for_game_reset
    return unless @input_args.inputs.keyboard.key_down.space

    # reset necessary state back to default
    @output_args.state.game_duration = 0
    @output_args.state.game_over = false
    @output_args.state.player = Player.new
    @output_args.state.objects = []
  end
end
