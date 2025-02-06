# This is a singleton class that is in charge of coordinating all game objects
# and drawing them to the screen each frame
require_relative 'base_object'
require_relative 'animated_object'
require_relative 'static_object'
require_relative 'environment_object'
require_relative 'background'
require_relative 'foreground'
require_relative 'sky_object'
require_relative 'player'
require_relative 'cactus'
require_relative 'pterodactyl'

NUM_SPRITES = {
  foreground: 7,
  background: 1,
  skyobject: 1
}

class GameObject
  # Initialize should only be called once, the very
  # first tick. After that, each tick is still referencing
  # the same GameObject instance.
  def initialize(args)
    @input_args = args
    @output_args = args

    # This is a brand new game, so treat it the same as a
    # reset.
    handle_reset
  end

  attr_accessor :game_over, :next_enemy_spawn, :is_day, :player, :input_args, :output_args, :game_duration

  # Called each tick to set the args instance vars to the
  # new args from the dragonruby engine.
  def update_args(new_args:)
    @input_args = new_args
    @output_args = new_args
  end

  # This is the main method that gets called every frame
  # it does all the necessary calculations and rendering
  def call
    add_new_objects
    handle_input
    handle_object_calculations
    handle_player_calculation

    handle_collisions

    render_environment
    render_ui
    render_output_args
    render_player

    @game_duration += 1 unless @game_over
  end

  def add_new_objects
    return if @game_over

    create_environment
    handle_enemy_spawn if ::Kernel.tick_count == @next_enemy_spawn
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
    @output_args.outputs.labels << { x: Grid.w - 150, y: Grid.h - 20, text: "Score: #{(@game_duration / 5).to_i}" }
  end

  def render_environment
    @output_args.state.environment_objects.each do |object|
      @output_args.outputs.sprites << object.to_sprite(is_day: @is_day)
    end
  end

  def render_output_args
    @output_args.state.objects.each do |object|
      @output_args.outputs.sprites << object.to_sprite(is_day: @is_day)
    end
  end

  def render_player
    @output_args.outputs.sprites << @player.to_sprite(is_day: @is_day)
  end

  def check_for_game_reset
    return unless @input_args.inputs.keyboard.key_down.space

    # reset necessary state back to default
    handle_reset
  end

  private
  def create_environment
    puts "Creating environment"
    [Foreground, Background, SkyObject].each do |klass|
      x = 0
      last_object = @output_args.state.environment_objects.select{ |object| object.is_a?(klass) }.last
      x = last_object.x if last_object

      while x&.<(Grid.w * 2)
        puts "Creating #{klass.name}"
        new_object = klass.new(x: x + (last_object&.w || 0), num_sprites: NUM_SPRITES[klass.to_s.downcase.to_sym])
        @output_args.state.environment_objects << new_object
        x = new_object.x
      end
    end
  end

  def handle_background_creation
    if @output_args.state.environment_objects.select{ |object| object.is_a?(Foreground) }.last.w < Grid.w * 2
      @output_args.state.environment_objects << Foreground.new
    end
  end

  def handle_enemy_spawn
    if rand(100) < 60
      @output_args.state.objects << Cactus.new(x: Grid.w, y: 0, w: 60, h: 80, x_velocity: -7, gravity: 0)
    else
      @output_args.state.objects << Pterodactyl.new(x: Grid.w, w: 80, h: 70, x_velocity: -9, gravity: 0)
    end
  end

  def handle_reset
    @game_duration = 0
    @game_over = false
    @player = Player.new
    puts "player x velocity: #{@player.x_velocity}"
    @next_enemy_spawn = get_next_enemy_spawn
    @output_args.state.objects = []
    @output_args.state.environment_objects = []
    @is_day = true
  end

  def get_next_enemy_spawn
    # Enemies start by spawning roughly every 1 second
    # and each 1500 ticks, the rough time between enemy
    # spawns is slightly decreased.
    Kernel.tick_count + 50 + rand(20) - (@game_duration / 1500)
  end
end
