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
DEFAULT_RUNNING_SPEED = -7 # negative because the player is stationary and everything else is moving backward

class GameObject
  # Initialize should only be called once, the very
  # first tick. After that, each tick is still referencing
  # the same GameObject instance.
  def initialize(args)
    @args = args

    # This is a brand new game, so treat it the same as a
    # reset.
    handle_reset
  end

  attr_reader :logger

  attr_accessor :game_over, :next_enemy_spawn, :is_day, :player, :args, :game_duration, :running_speed

  # This is the main method that gets called every frame
  # it does all the necessary calculations and rendering
  def call
    log "Handling Input"
    handle_input

    log "Rendering Environment"
    render_environment

    log "Rendering UI"
    render_ui

    log "Rendering Sprites"
    render_sprites

    log "Rendering Player"
    render_player

    return if @game_over

    # log "Increasing Running Speed"
    # handle_increase_running_speed if (@game_duration % 300).zero?

    log "Adding New Objects"
    add_new_objects

    log "Animating Objects"
    rotate_object_sprites

    log "Handling Object Calculations"
    handle_object_calculations

    log "Handling Collisions"
    handle_collisions

    log "Removing Old Objects"
    remove_old_objects

    log "Incrementing Game Duration"
    @game_duration += 1
  end

  def add_new_objects
    create_new_environment
    handle_enemy_spawn if Kernel.tick_count == @next_enemy_spawn
  end

  def handle_input
    if @game_over
      check_for_game_reset
    else
      @player.handle_input(args: @args)
    end
  end

  def handle_object_calculations
    @args.state.objects.each(&:calc)
    @args.state.environment_objects.each(&:calc)
    @player.calc
  end

  def handle_collisions
    return unless @player.check_for_collisions(objects: @args.state.objects.select(&:damages_player?))

    handle_game_over
  end

  def handle_game_over
    @game_over = true
    # @args.state.objects.each do |object|
    #   object.x_velocity = 0
    #   object.y_velocity = 0
    #   object.x_acceleration = 0
    #   object.y_acceleration = 0
    # end

    # @args.state.environment_objects.each do |object|
    #   object.x_velocity = 0
    #   object.y_velocity = 0
    #   object.x_acceleration = 0
    #   object.y_acceleration = 0
    # end
  end

  def render_ui
    @args.outputs.labels << { x: Grid.w - 150, y: Grid.h - 20, text: "Score: #{(@game_duration / 5).to_i}" }
  end

  def render_environment
    [SkyObject, Background, Foreground].each do |klass|
      @args.state.environment_objects.select{ |object| object.is_a?(klass) }.each do |object|
        # log object.sprite_path(is_day: @is_day)
        @args.outputs.sprites << object.to_sprite(is_day: @is_day)
      end
    end
  end

  def render_sprites
    @args.state.objects.each do |object|
      @args.outputs.sprites << object.to_sprite(is_day: @is_day)
    end
  end

  def render_player
    @args.outputs.sprites << @player.to_sprite(is_day: @is_day)
  end

  def check_for_game_reset
    return unless @args.inputs.keyboard.key_down.space

    # reset necessary state back to default
    handle_reset
  end

  private

  def create_new_environment
    log "Creating environment"

    [Foreground, Background, SkyObject].each do |klass|
      last_object = @args.state.environment_objects.select{ |object| object.is_a?(klass) }.last
      where_to_put_the_next_object_created = last_object&.x&.+(last_object&.w) || 0

      puts "last_object: #{last_object.inspect}" unless klass == Foreground
      puts "where_to_put_the_next_object_created: #{where_to_put_the_next_object_created}" unless klass == Foreground

      return if where_to_put_the_next_object_created > Grid.w * 3

      ((Grid.w * 3) / klass::SPRITE_WIDTH).to_i.times do
        new_object = klass.new(x: where_to_put_the_next_object_created)
        @args.state.environment_objects << new_object
        where_to_put_the_next_object_created += new_object.w
      end
    end
  end

  def remove_old_objects
    @args.state.environment_objects = @args.state.environment_objects.select{ |object| (object.x + object.w).positive? }
    @args.state.objects = @args.state.objects.select{ |object| (object.x + object.w).positive? }
  end

  def rotate_object_sprites
    @args.state.objects.select{ |object| object.is_a?(AnimatedObject) }.each(&:rotate_sprite)
    @player.rotate_sprite
  end

  def handle_enemy_spawn
    if rand(100) < 60
      @args.state.objects << Cactus.new
    else
      @args.state.objects << Pterodactyl.new
    end

    set_next_enemy_spawn
  end

  # def handle_increase_running_speed
  #   @running_speed -= 1

  #   @args.state.objects.each do |object|
  #     object.x_velocity = @running_speed
  #   end

  #   @args.state.environment_objects do |object|
  #     object.x_velocity = @running_speed
  #   end
  # end

  def handle_reset
    @game_duration = 0
    @game_over = false
    @player = Player.new
    set_next_enemy_spawn
    @args.state.objects = []
    @args.state.environment_objects = []
    @is_day = true
    @running_speed = DEFAULT_RUNNING_SPEED
  end

  def set_next_enemy_spawn
    # Enemies start by spawning roughly every 2 seconds
    # and each 1500 ticks, the rough time between enemy
    # spawns is slightly decreased.
    @next_enemy_spawn = (Kernel.tick_count + 120 + rand(20) - (@game_duration / 1500)).to_i
  end

  def log(message)
    return unless LOGGER

    puts message
  end
end
