# This is the main class that is in charge of coordinating all game objects
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

ZOOM_COEFFICIENT = 4
GROUND_LEVEL = Foreground::SPRITE_HEIGHT * ZOOM_COEFFICIENT
RUNNING_SPEED = -7 # negative because the player is stationary and everything else is moving backward

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

  attr_reader :logger

  attr_accessor :game_over, :next_enemy_spawn, :is_day, :player, :input_args, :output_args, :game_duration

  # This is the main method that gets called every frame
  # it does all the necessary calculations and rendering
  def call
    log "Resetting Args"
    @input_args = @output_args

    log "Adding New Objects"
    add_new_objects

    log "Handling Input"
    handle_input

    log "Handling Object Calculations"
    handle_object_calculations

    log "Handling Player Calculation"
    handle_player_calculation

    log "Handling Collisions"
    handle_collisions

    log "Removing Old Objects"
    remove_old_objects

    log "Rendering Environment"
    render_environment

    log "Rendering UI"
    render_ui

    log "Rendering Sprites"
    render_sprites

    log "Rendering Player"
    render_player

    log "Incrementing Game Duration"
    @game_duration += 1 unless @game_over
  end

  def add_new_objects
    return if @game_over

    create_new_environment
    handle_enemy_spawn if Kernel.tick_count == @next_enemy_spawn
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

    @output_args.state.objects.each(&:calc)
    @output_args.state.environment_objects.each(&:calc)
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
      # log object.sprite_path(is_day: @is_day)
      @output_args.outputs.sprites << object.to_sprite(is_day: @is_day)
    end
  end

  def render_sprites
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

  def create_new_environment
    log "Creating environment"

    [Foreground, Background, SkyObject].each do |klass|
      last_object = @input_args.state.environment_objects.select{ |object| object.is_a?(klass) }.last
      where_to_put_the_next_object_created = last_object&.x&.+(last_object&.w) || 0

      return if where_to_put_the_next_object_created > Grid.w * 2

      puts "last_object: #{last_object.inspect}" if klass == Foreground
      puts "x: #{where_to_put_the_next_object_created}" if klass == Foreground

      new_object = klass.new(x: where_to_put_the_next_object_created)
      @output_args.state.environment_objects << new_object

      puts "New #{klass.name} Created: #{new_object.inspect}" if klass == Foreground
    end
  end

  def remove_old_objects
    @output_args.state.environment_objects = @output_args.state.environment_objects.select{ |object| (object.x + object.w).positive? }
    @output_args.state.objects = @output_args.state.objects.select{ |object| (object.x + object.w).positive? }
  end

  def handle_enemy_spawn
    if rand(100) < 60
      @output_args.state.objects << Cactus.new
    else
      @output_args.state.objects << Pterodactyl.new
    end

    set_next_enemy_spawn
  end

  def handle_reset
    @game_duration = 0
    @game_over = false
    @player = Player.new
    set_next_enemy_spawn
    @output_args.state.objects = []
    @output_args.state.environment_objects = []
    @is_day = true
  end

  def set_next_enemy_spawn
    # Enemies start by spawning roughly every 1 second
    # and each 1500 ticks, the rough time between enemy
    # spawns is slightly decreased.
    @next_enemy_spawn = (Kernel.tick_count + 50 + rand(20) - (@game_duration / 1500)).to_i
  end

  def log(message)
    return unless LOGGER

    puts message
  end
end
