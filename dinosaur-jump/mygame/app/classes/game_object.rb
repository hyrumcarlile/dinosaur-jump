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
    @high_score = 0

    # This is a brand new game, so treat it the same as a
    # reset.
    handle_reset
  end

  attr_reader :logger

  attr_accessor :game_over, :next_enemy_spawn, :is_day, :player, :args, :game_duration, :running_speed, :score, :day_changed_at, :game_over_at

  # This is the main method that gets called every frame
  # it does all the necessary calculations and rendering
  def call
    game_actions
    render_actions
  end

  def render_actions
    # Order is important! The objects later in the @args.outputs.sprites
    # array are rendered on top
    log "Handling Input"
    handle_input

    log "Rendering Environment"
    render_environment

    log "Rendering Sprites"
    render_sprites

    log "Rendering Player"
    render_player

    log "Rendering UI"
    render_ui
  end

  def game_actions
    return if @game_over

    log "Updating Time of Day"
    handle_day_change

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
    return if @game_over_at && Kernel.tick_count - @game_over_at < 100
    if @game_over
      check_for_game_reset
    else
      @player.handle_input(args: @args)
    end
  end

  def handle_object_calculations
    @args.state.objects.each(&:calc)
    @args.state.sky_objects.each(&:calc)
    @args.state.background_objects.each(&:calc)
    @args.state.foreground_objects.each(&:calc)
    @player.calc
  end

  def handle_collisions
    return unless @player.check_for_collisions(objects: @args.state.objects.select(&:damages_player?))

    handle_collision
  end

  def handle_collision
    handle_game_over if @player.lives.zero?
  end

  def handle_game_over
    @game_over = true
    @game_over_at = Kernel.tick_count
  end

  def render_ui
    @args.outputs.labels << { x: Grid.w - 300, y: Grid.h - 20, text: "Distance Traveled: #{distance(@score)}" }
    @args.outputs.labels << { x: Grid.w - 190, y: Grid.h - 40, text: "Record: #{distance(@high_score)}" }

    @args.outputs.sprites << {w: Grid.w - 500, h: Grid.h - 100, x: 250, y: 100, path: 'sprites/ui/game_over.png'} if @game_over
    @args.outputs.labels << { x: (Grid.w / 2) - 100, y: 220, text: "Press Space to Reset" } if @game_over_at && Kernel.tick_count - @game_over_at >= 100

    current_life_index = 0
    @player.lives.times do
      @args.outputs.sprites << {x: 30 + current_life_index * 40, y: Grid.h - 40, w: 19 * 2, h: 16 * 2, path: 'sprites/ui/heart-full.png' }
      current_life_index += 1
    end
    (@player.max_lives - @player.lives).times do
      @args.outputs.sprites << {x: 30 + current_life_index * 40, y: Grid.h - 40, w: 19 * 2, h: 16 * 2, path: 'sprites/ui/heart-empty.png' }
      current_life_index += 1
    end
  end

  def render_environment
    # Order is important! The objects later in the @args.outputs.sprites
    # array are rendered on top
    @args.outputs.sprites << @args.state.sky_objects.map{ |object| object.to_sprite(is_day: @is_day) }
    @args.outputs.sprites << @args.state.background_objects.map{ |object| object.to_sprite(is_day: @is_day) }
    @args.outputs.sprites << @args.state.foreground_objects.map{ |object| object.to_sprite(is_day: @is_day) }
  end

  def render_sprites
    @args.outputs.sprites << @args.state.objects.map{ |object| object.to_sprite(is_day: @is_day) }
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

    # Create Sky
    last_object = @args.state.sky_objects.last
    where_to_put_the_next_object_created = last_object&.x&.+(last_object&.w) || 0

    ((Grid.w * 1.5) / SkyObject::SPRITE_WIDTH).to_i.times do
      new_object = SkyObject.new(x: where_to_put_the_next_object_created)
      @args.state.sky_objects << new_object
      where_to_put_the_next_object_created += new_object.w
    end unless where_to_put_the_next_object_created > Grid.w * 1.5

    # Create Background
    last_object = @args.state.background_objects.last
    where_to_put_the_next_object_created = last_object&.x&.+(last_object&.w) || 0

    ((Grid.w * 1.5) / Background::SPRITE_WIDTH).to_i.times do
      new_object = Background.new(x: where_to_put_the_next_object_created)
      @args.state.background_objects << new_object
      where_to_put_the_next_object_created += new_object.w
    end unless where_to_put_the_next_object_created > Grid.w * 1.5

    # Create Foreground
    last_object = @args.state.foreground_objects.last
    where_to_put_the_next_object_created = last_object&.x&.+(last_object&.w) || 0

    ((Grid.w * 1.5) / Foreground::SPRITE_WIDTH).to_i.times do
      new_object = Foreground.new(x: where_to_put_the_next_object_created)
      @args.state.foreground_objects << new_object
      where_to_put_the_next_object_created += new_object.w
    end unless where_to_put_the_next_object_created > Grid.w * 1.5
  end

  def remove_old_objects
    # increment @score for every foreground object that the player runs past
    @score += @args.state.foreground_objects.select{ |object| (object.x + object.w).negative? }.length
    @high_score = @score if @score > @high_score

    # remove sprites to left of the grid from memory
    @args.state.background_objects = @args.state.background_objects.select{ |object| (object.x + object.w).positive? }
    @args.state.foreground_objects = @args.state.foreground_objects.select{ |object| (object.x + object.w).positive? }
    @args.state.objects = @args.state.objects.select{ |object| (object.x + object.w).positive? }
  end

  def rotate_object_sprites
    @args.state.objects.select{ |object| object.is_a?(AnimatedObject) }.each(&:rotate_sprite)
    @player.rotate_sprite
  end

  def handle_day_change
    return unless (@score % 100).zero?
    return if @score == 0
    return if Kernel.tick_count - @day_changed_at < 100

    @is_day = !@is_day
    @day_changed_at = Kernel.tick_count
  end

  def handle_enemy_spawn
    if rand(100) < 60
      (rand(3) + 1).times do |i|
        @args.state.objects << Cactus.new(x: Grid.w + i * Cactus::SPRITE_WIDTH * ZOOM_COEFFICIENT)
      end
    else
      (rand(3) + 1).times do |i|
        pterodactyl = Pterodactyl.new(x: Grid.w + i * Pterodactyl::SPRITE_WIDTH * ZOOM_COEFFICIENT)
        pterodactyl.y += (i * Pterodactyl::SPRITE_HEIGHT * ZOOM_COEFFICIENT)
        @args.state.objects << pterodactyl
      end
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
    @score = 0
    @game_over = false
    @game_over_at = nil
    @player = Player.new
    set_next_enemy_spawn
    @args.state.objects = []
    @args.state.sky_objects = []
    @args.state.background_objects = []
    @args.state.foreground_objects = []
    @is_day = true
    @running_speed = DEFAULT_RUNNING_SPEED
    @day_changed_at = Kernel.tick_count
  end

  def set_next_enemy_spawn
    # Enemies start by spawning roughly every 2 seconds
    # and each 100 score, the rough time between enemy
    # spawns is slightly decreased.
    @next_enemy_spawn = (Kernel.tick_count + 120 + rand(20) - (@score / 100)).to_i
  end

  def distance(number)
    digits = number.to_s.length

    case digits
    when 1..3
      return "#{number}m"
    when 4..6
      return "#{sprintf('%.2f', number / 1000.0)}km"
    end
  end

  def log(message)
    return unless LOGGER

    puts message
  end
end
